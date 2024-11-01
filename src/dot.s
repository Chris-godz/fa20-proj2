.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    # Prologue
    bge x0, a2, error_len
    bge x0, a3, error_stride
    bge x0, a4, error_stride
    add t0, x0, x0
    add t1, x0, x0
loop_start:
    bge t1, a2, loop_end 
    slli t2, t1, 2
    
    mul t3, t2, a3
    mul t4, t2, a4

    add t3, a0, t3
    add t4, a1, t4
    lw t3, 0(t3)
    lw t4, 0(t4)
    mul t5, t3, t4
    add t0, t0, t5
    addi t1, t1, 1
    j loop_start
error_len:
    addi a0, x0, 17
    addi a1, x0, 75
    ecall
error_stride:
    addi a0, x0, 17
    addi a1, x0, 76
    ecall
loop_end:

    # Epilogue
    mv a0 t0
    ret
