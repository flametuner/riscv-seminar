.equ MAX_HARTS,    4
.equ STACK_SIZE,   1024
.equ STACK_SHIFT,  10

.section .text.init,"ax"
.globl _start

_start:
    # set up stack pointer based on hartid
    csrr    t0, mhartid
    slli    t0, t0, STACK_SHIFT
    la      sp, stacks + STACK_SIZE
    add     sp, sp, t0

    # jump to libfemto_start_main
    j       main

stacks:
    .skip STACK_SIZE * MAX_HARTS
