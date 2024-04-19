.PHONY: runtime build generate build-quick

NAME = macro
VERSION = $(shell git describe --tags | sed 's;^v;;')
HASH = $(shell git rev-parse --short HEAD)
DATE = $(shell date +%F)
ADDITIONAL_GO_LINKER_FLAGS = $(shell GOOS=$(shell go env GOHOSTOS) GOARCH=$(shell go env GOHOSTARCH))
GOBIN ?= $(shell go env GOPATH)/bin
GOVARS = -X github.com/zyedidia/micro/v2/internal/util.Version=$(VERSION) -X github.com/zyedidia/micro/v2/internal/util.CommitHash=$(HASH) -X 'github.com/zyedidia/micro/v2/internal/util.CompileDate=$(DATE)'
DEBUGVAR = -X github.com/zyedidia/micro/v2/internal/util.Debug=ON

all: build
	@echo
	@file ./$(NAME)

update:
	@git remote add upstream https://github.com/zyedidia/micro 2>/dev/null || true
	git pull --rebase upstream master

upgrade: update
	go get -u ./...

build: generate build-quick

build-quick:
	go build -trimpath -ldflags "-s -w $(GOVARS) $(ADDITIONAL_GO_LINKER_FLAGS)" ./cmd/$(NAME)

build-dbg:
	go build -trimpath -ldflags "-s -w $(ADDITIONAL_GO_LINKER_FLAGS) $(DEBUGVAR)" ./cmd/$(NAME)

build-tags: fetch-tags generate
	go build -trimpath -ldflags "-s -w $(GOVARS) $(ADDITIONAL_GO_LINKER_FLAGS)" ./cmd/$(NAME)

build-all: build

install: generate
	go install -ldflags "-s -w $(GOVARS) $(ADDITIONAL_GO_LINKER_FLAGS)" ./cmd/$(NAME)
	@mkdir -p ~/.local/share/applications/
	cp -f ./runtime/$(NAME).desktop ~/.local/share/applications/

install-all: install

generate:
	GOOS=$(shell go env GOHOSTOS) GOARCH=$(shell go env GOHOSTARCH) go generate ./runtime

test:
	go test ./internal/...
	go test ./cmd/...

bench:
	for i in 1 2 3; do \
		go test -bench=. ./internal/...; \
	done > benchmark_results
	benchstat benchmark_results

bench-baseline:
	for i in 1 2 3; do \
		go test -bench=. ./internal/...; \
	done > benchmark_results_baseline

bench-compare:
	for i in 1 2 3; do \
		go test -bench=. ./internal/...; \
	done > benchmark_results
	benchstat -alpha 0.15 benchmark_results_baseline benchmark_results

clean:
	rm -f ./$(NAME)
