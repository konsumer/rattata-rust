# WIP

This is some ideas round using rust for [rattata](https://github.com/notnullgames/rattata).


## TODO

This is basically just `helloworld`, now.

- create tor tunnel, runtime connects to manager on startup
- add basic commands (`download` & `run`)
- add VFS to store downloaded files & add vfs file management commands
- add a way to inject initial VFS & config (like zip at end of binary)
- add advanced runtime commands (load this dll, do stuff with it, etc)
- make manager a DLL, and wrap it with lua (and other languages) via FFI
- build for OSX