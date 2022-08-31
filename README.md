# Cosmopolitan Libc for Nim

This is a simple example to show how can you use [Cosmopolitan](https://github.com/jart/cosmopolitan) with Nim.
Directory structure:
- `stubs` - contains empty include files that Nim expects to be available. Cosmopolitan provides all of these 
in a single include file.

- `hello.nim` - Nim file that we want to compile

- `nim.cfg` - Neccessary configuration file to set all the C compiler options to the ones required by Cosmopolitan.

First you need to get the Cosmopolitan itself - simply go to [the downloads](https://justine.lol/cosmopolitan/download.html) and 
grab the latest release (0.2 as of 03-03-2021). Then extract it into the `cosmopolitan` folder so that it looks something like this:
```
cosmopolitan/
├── ape.lds
├── ape.o
├── cosmopolitan.a
├── cosmopolitan.h
└── crt.o
```


Now you can actually compile the first example with:
```
# Compile an ELF binary
nim c -d:danger --opt:size -o:hello.elf hello.nim

# Get the actual portable executable
objcopy -SO binary hello.elf hello.com
```

You might also use `--gc:arc` or `--gc:orc` in conjuction with `-d:useMalloc` to create a smaller and potentially faster
binary (either add it to the compilation command-line or to the nim.cfg)

If you import some other stdlib modules and the compilation fails, first check if the C compiler is complaining about missing
headers - if so, just add that header into the `stubs` directory (just create an empty file with the right directory hierarchy),
and it'll probably work :P

Apart from `hello.nim`, this repo also has `gethttp.nim` and `asyncserv.nim`. To compile them you need to apply the `asyncserv.diff` patch
to your local Nim installation. This is also pretty simple:
```
cd nimGitDir
git apply /path/to/cosmonim/asyncserv.diff 
```

Then you can compile those examples as usual.