.section .text
.global _start
_start:
    la sp, _stack_top
    la a0, _sidata
    la a1, _sdata
    la a2, _edata
    bge a1, a2, zero_bss
copy_data_loop:
    lw t0, 0(a0)
    sw t0, 0(a1)
    addi a0, a0, 4
    addi a1, a1, 4
    blt a1, a2, copy_data_loop
zero_bss:
    la a0, _sbss
    la a1, _ebss
    bge a0, a1, call_main
zero_bss_loop:
    sw zero, 0(a0)
    addi a0, a0, 4
    blt a0, a1, zero_bss_loop
call_main:
    call main
hang:
    j hang