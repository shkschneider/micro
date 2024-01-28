# ![Macro](runtime/macro.svg) Macro [![Go](https://img.shields.io/badge/go-391A80)](https://go.dev) [![Lua](https://img.shields.io/badge/lua-391A80)](https://lua.org)

> Modeless (simple) terminal text editor done right.

**macro** is a fork of the Micro editor providing a separate configuration path and additional features to suit my taste.

**micro** by [Zachary Yedidia](https://github.com/zyedidia) is a terminal-based text editor that aims to be easy to use and intuitive, while also taking advantage of the capabilities of modern terminals.

Head over [Micro-Editor's website](https://micro-editor.github.io) for more informations.

## Main features

- Modeless editor: like what you're probably used to.
- Written in go, easy and fast to compile: and most likely cross-platform (where Go runs on).
- Sane defaults and keybindings (^S, ^C, ^V, ^Q…).
- Easy configuration via JSON.
- Easy plugins via Lua.
- Multiple cursors.
- Splits and tabs.
- Wonderful mouse support (selection, drag, double-click, triple-click…).
- Diff gutter and line numbers.
- Simple autocompletion.
- Syntax highlighting for 100+ languages.
- Theming: color scheme support (16, 256 and true color support).
- Macros.
- Common editor features such as (persistent) undo/redo, Unicode support, soft wrapping…

## Building from source

Make sure that you have Go version 1.16 or greater and Go modules are enabled.

```
git clone https://github.com/shkschneider/macro
cd micro
go get github.com/zyedidia/clipboard
go get github.com/zyedidia/tcell
go get github.com/zyedidia/micro/cmd/micro/shellwords
make build
```

The binary (`./macro`) will be placed in the current directory and can be moved to
anywhere you like (for example `/usr/local/bin`).

The command `make install` will install the binary to `$GOPATH/bin` or `$GOBIN`.
A desktop entry file can also be found in the `runtime` directory.

## Usage

- Use `macro -version` to get the verson information after installing.
- Use `macro <path/to/file>` to open a file.
- Use `macro <path/to/directory>` to browse files in this directory
  (requires [fd](https://github.com/sharkdp/fd) and [fzf](https://github.com/junegunn/fzf)).
- Macro also supports creating buffers from `stdin`.

You can move the cursor around with the arrow keys and mouse.
Save with Ctrl-S, quit with Ctrl-Q.
Run (and explore) commands with Ctrl-Space.

**Note for Linux desktop environments:**

For interfacing with the local system clipboard, the following tools need to be installed:
* For X11, `xclip` or `xsel`
* For [Wayland](https://wayland.freedesktop.org/), `wl-clipboard`
Without these tools installed, macro will use an internal clipboard for copy and paste, but it won't be accessible to external applications.

## Documentation (Upstream)

- This is a fork of Micro by Zachary Yedidia.
- [Micro's documentation](https://github.com/zyedidia/micro/tree/master/runtime/help/help.md)

As for exploring the code, use `grep` extensively and start with:
[actions.go](internal/actions/actions.go)
[bufpane.go](internal/actions/bufpane.go)
[buffer.go](internal/buffer/buffer.go)

Please do NOT report any bug upstream as those could be mine!
