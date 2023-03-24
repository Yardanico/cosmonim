# Cosmopolitan Libc for Nim

This is a simple example to show how can you use [Cosmopolitan](https://github.com/jart/cosmopolitan) with Nim.

**Clone with `git clone --recursive https://github.com/Yardanico/cosmonim`**

Directory structure:
- `stubs` - a Git submodule pointing to https://github.com/fabriziobertocci/cosmo-include which has a lot of empty headers that make Nim happy because otherwise it won't find the needed headers. 

- `hello.nim` - Nim file that we want to compile

- `nim.cfg` - Neccessary configuration file to set all the C compiler options to the ones required by Cosmopolitan.

First you need to get the Cosmopolitan itself - simply go to [the downloads](https://justine.lol/cosmopolitan/download.html) and 
grab the latest release (2.2 as of 2023-03-24). Then extract it into the `cosmopolitan` folder so that it looks something like this:
```
cosmopolitan
├── ape-copy-self.o
├── ape.lds
├── ape-no-modify-self.o
├── ape.o
├── cosmopolitan.a
├── cosmopolitan.h
└── crt.o
```


Now you can actually compile the first example with:
```
# Compile the ELF binary
nim c -d:danger --opt:size -o:hello.elf hello.nim

# Get the actual portable executable
objcopy -SO binary hello.elf hello.com
```

`nim.cfg` in the repo also enables `--mm:orc` by default, which is a better choice for "unusual" targets like embedded
systems or Cosmopolitan. If you wish to use the default GC, change it to `--mm:refc` instead.

If you import some other stdlib modules and the compilation fails, first check if the C compiler is complaining about missing
headers - if so, just add that header into the `stubs` directory (just create an empty file with the right directory hierarchy),
and it'll probably work :P

Apart from `hello.nim`, this repo also has `gethttp.nim` (test of using the Nim http client) and `asyncserv.nim` (test of using the Nim async HTTP server). 
To compile `asyncserv.nim` you need to pass `-d:android` (since it disables some stuff that's not present on Android nor in Cosmopolitan), like this:
```
nim c -d:danger --opt:size -d:android -o:hello.elf asyncserv.nim
objcopy -SO binary hello.elf hello.com
```

`-d:android` in Nim also changes some other things, like making Nim use Clang by default (hence the `--cc:gcc` in `nim.cfg`) but as far as I know it shouldn't affect Cosmopolitan-built programs too much. A better solution would be to add `cosmLibc` define to Nim itself in all relevant places.
