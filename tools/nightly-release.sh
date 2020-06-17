# This script creates the nightly release on Github for micro
# Must be run from inside the micro git repository

commitID=$(git rev-parse HEAD)
info=$(github-release info -u zyedidia -r micro -t nightly)

if [[ $info = *$commitID* ]]; then
    echo "No new commits since last nightly"
    exit 1
fi

go run remove-nightly-assets.go

echo "Moving tag"
hub push origin :refs/tags/nightly
git tag -f nightly $commitID
hub push --tags

echo "Cross compiling binaries"
./cross-compile.sh $1
mv ../binaries .

MESSAGE=$'Nightly build\n\nAutogenerated nightly build of micro'

echo "Creating new release"
hub release edit nightly \
    --prerelease \
    --message "$MESSAGE. Assets uploaded on $(date)" \
    --attach "binaries/micro-$1-osx.tar.gz" \
    --attach "binaries/micro-$1-linux64.tar.gz" \
    --attach "binaries/micro-$1-linux64-static.tar.gz" \
    --attach "binaries/micro-$1-linux32.tar.gz" \
    --attach "binaries/micro-$1-linux-arm.tar.gz" \
    --attach "binaries/micro-$1-linux-arm64.tar.gz" \
    --attach "binaries/micro-$1-freebsd64.tar.gz" \
    --attach "binaries/micro-$1-freebsd32.tar.gz" \
    --attach "binaries/micro-$1-openbsd64.tar.gz" \
    --attach "binaries/micro-$1-openbsd32.tar.gz" \
    --attach "binaries/micro-$1-netbsd64.tar.gz" \
    --attach "binaries/micro-$1-netbsd32.tar.gz" \
    --attach "binaries/micro-$1-win64.zip" \
    --attach "binaries/micro-$1-win32.zip"
