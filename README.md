# Odin Shared

## Folder structure

```txt
path                           env.var.
-------------------------------------------------
/.
	/odin                      %ODIN_ROOT%
		/odin.exe
		.
		.
	/shared                    %ODIN_SHARED%
		/coreclr
		/flac
		/fmodex
		/newtek_lightwave
		/ounit
		/owin
		/wasmtime
		/xatlas
		/xterm
		/z80
	/projects
	.
	.
```

## Shared

```bat
git submodule add git@github.com:Hyrtwol/odin-shared.git shared
```

## Submodules

```bat
git submodule add git@github.com:Hyrtwol/odin-ounit.git ounit
```

`ounit` is shared by the other modules to help with testing.

```bat
git submodule add git@github.com:Hyrtwol/odin-coreclr.git coreclr
git submodule add git@github.com:Hyrtwol/odin-flac.git flac
git submodule add git@github.com:Hyrtwol/odin-fmodex.git fmodex
git submodule add git@github.com:Hyrtwol/odin-newtek_lightwave.git newtek_lightwave
git submodule add git@github.com:Hyrtwol/odin-newton_dynamics.git newton_dynamics
git submodule add git@github.com:Hyrtwol/odin-wasmtime.git wasmtime
git submodule add git@github.com:Hyrtwol/odin-xatlas.git xatlas
git submodule add git@github.com:Hyrtwol/odin-xterm.git xterm
git submodule add git@github.com:Hyrtwol/odin-z80.git z80
```

### Update

```bat
git submodule update --recursive
git submodule update --init --recursive
```
