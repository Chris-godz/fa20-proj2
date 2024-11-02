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
    addi sp, sp, -44
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6
    add s7, x0, x0 #i
    add s8, x0, x0 #j
outer_loop_start:
    bge s7, s1, outer_loop_end
inner_loop_start:
    bge s8, s5, inner_loop_end
    
    mul t0, s7, s2
    slli t0, t0, 2
    add a0, s0, t0
    slli t0, s8, 2
    add a1, s3, t0
    mv a2, s2
    addi a3, x0, 1
    mv a4, s5
    jal dot
    
    slli t0, s7, 2
    mul t1, t0, s5
    slli t0, s8, 2
    add t1, t1, t0
    add t1, t1, s6 
    sw a0, 0(t1)

    addi s8, s8, 1
    j inner_loop_start
inner_loop_end:
    addi s7, s7, 1
    addi s8, x0, 0
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
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    addi sp, sp, 44
    ret
