# riscv-seminar

This is a simple version of `riscv-probe` and it's used for learning purposes. The main goal of this project is to learn about how UART works with RISC-V.

## Dependencies

A recent version of `riscv-tools` with a multilib build of RISC-V GCC.

- [riscv-tools](https://github.com/riscv/riscv-tools)
  - [riscv-isa-sim](https://github.com/riscv/riscv-isa-sim)
  - [riscv-openocd](https://github.com/riscv/riscv-openocd)
  - [riscv-gnu-toolchain](https://github.com/riscv/riscv-gnu-toolchain)
- [riscv-qemu](https://github.com/riscv/riscv-qemu)

## Build

The build system uses `CROSS_COMPILE` as the toolchain prefix and expects
the toolchain to be present in the `PATH` environment variable. The default
value for `CROSS_COMPILE` is `riscv64-unknown-elf-` however this can be
overridden e.g. `make CROSS_COMPILE=riscv64-unknown-linux-gnu-`. The build
system expects a multilib toolchain as it uses the same toolchain to build
for _riscv32_ and _riscv64_. Make sure to use `--enable-multilib` when
configuring [riscv-gnu-toolchain](https://github.com/riscv/riscv-gnu-toolchain).
The examples are all built with `-nostartfiles -nostdlib -nostdinc` so either
the RISC-V GCC Newlib toolchain or RISC-V GCC Glibc Linux toolchain can be used.

To build the examples after environent setup, type:

```
$ make
```

## Running

To run the hello world program in RISC-V QEMU virt:
```
$ qemu-system-riscv64 -nographic -machine virt -bios none -kernel build/bin/rv64imac/virt/hello
```