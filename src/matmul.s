.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    # Error checks
    bge x0, a1, error_m0
    bge x0, a2, error_m0
    bge x0, a4, error_m1
    bge x0, a5, error_m1
    bne a2, a4, error_match
    # Prologue
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6
    add t0, x0, x0 #i
    add t1, x0, x0 #j
outer_loop_start:
    bge t0, s1, outer_loop_end
    slli t2, t0, 2
    mul t2, t2, s2
inner_loop_start:
    bge t1, s2, inner_loop_end
    slli t3, t1, 2
    addi sp, sp, -12
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    add a0, s0, t2  
    add a1, s3, t3
    mv a2 s2
    addi a3, x0, 1
    mv a4, s5
    jal dot
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    addi sp, sp, 12
    
    slli t3, t1, 2
    add t4, t2, t3 #offset
    add t5, s6, t4
    sw a0, 0(t5)

    addi t1, t1, 1
    j inner_loop_start
inner_loop_end:
    addi t0, t0, 1
    addi t1, x0, 0
    j outer_loop_start
error_m0:
    addi a0, x0, 17
    addi a1, x0, 72
    ecall
error_m1:
    addi a0, x0, 17
    addi a1, x0, 73
    ecall
error_match:
    addi a0, x0, 17
    addi a1, x0, 74
    ecall
outer_loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    ret
