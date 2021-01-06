NAME=rattata

.PHONY: help clean manager target ffitest

help: ## show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

manager: ## run rattata manager
	cargo run --bin manager

runtime: ## run rattata target runtime
	cargo run --bin runtime

clean: ## delete all output files
	cargo clean

build: ## build runtime files in target/
	# whatever is local
	cargo build --bins --lib --release

cross: ## build runtime files for all supported platforms in target/
	# desktop linux
	cross build --bins --lib --release --target=x86_64-unknown-linux-gnu
	# windows
	cross build --bins --lib --release --target=x86_64-pc-windows-gnu
	# mac
	cross build --bins --lib --release --target=x86_64-apple-darwin
	# pi 0/1
	cross build --bins --lib --release --target=arm-unknown-linux-gnueabihf
	# pi 2/3/4
	cross build --bins --lib --release --target=armv7-unknown-linux-gnueabihf

ffi: build ## test that ffi works using src/test.lua
	cp src/test.lua target/release && luajit target/release/test.lua