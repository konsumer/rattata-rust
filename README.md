# WIP

This is some ideas round using rust for [rattata](https://github.com/notnullgames/rattata).


## TODO

This is basically just `helloworld`, now.

- create tor tunnel, runtime connects to manager on startup
- add basic commands (`download` & `exec`)
- add VFS to store downloaded files & add vfs file management commands (`ls`, `rm`, `cat`) - maybe no dirs, just flat location
- add a way to inject initial VFS & config (like zip at end of binary)
- add advanced runtime commands (load this dll, do stuff with it, etc)
- make manager a DLL, and wrap it with lua (and other languages) via FFI
- runtime perisitance & hiding
- build for OSX
