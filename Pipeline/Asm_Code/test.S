/* --- Reset Vector ---
 * We place the startup code in its own section, which the linker script
 * will map to the RESET_VEC memory region. "ax" means allocatable and executable.
 */
.section .reset_vector, "ax"
.global _start

_start:
    # 1. Initialize the main Stack Pointer (sp).
    # The stack grows downwards, so we point to the top of the STACK region.
    la sp, _stack_top

    # 2. (Optional) Initialize the CSR Stack Pointer if needed.
    # This would typically be for a separate stack for machine-mode handlers.
    # la tp, _csr_stack_top # Using 'tp' as an example for a second stack pointer

    # 3. Copy initialized data from ROM (.sidata) to RAM (.sdata).
    la a0, _sidata  # a0 = Source address in ROM
    la a1, _sdata   # a1 = Destination address in RAM
    la a2, _edata   # a2 = End address in RAM
    bge a1, a2, zero_bss # Skip if no data to copy

copy_data_loop:
    lw t0, 0(a0)
    sw t0, 0(a1)
    addi a0, a0, 4
    addi a1, a1, 4
    blt a1, a2, copy_data_loop

zero_bss:
    # 4. Initialize the .bss section (uninitialized data) to zeros in RAM.
    la a0, _sbss    # a0 = Start of .bss
    la a1, _ebss    # a1 = End of .bss
    bge a0, a1, call_main # Skip if .bss is empty

zero_bss_loop:
    sw zero, 0(a0) # 'zero' is a hardwired register in RISC-V that always reads 0
    addi a0, a0, 4
    blt a0, a1, zero_bss_loop

call_main:
    # 5. Jump to the main C function.
    call main

    # If main ever returns, hang here.
hang:
    j hang


/* --- Trap Vector ---
 * Place the trap handler code in its own section. The linker script
 * will map this to the TRAP_VEC memory region.
 */
.section .trap_vector, "ax"
.global trap_handler

trap_handler:
    # Your trap handling logic would go here.
    # For now, it's just an infinite loop.
    mret

.global main

main: # etc