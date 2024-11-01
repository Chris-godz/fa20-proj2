.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    bge x0, a1, error
    add t1, x0, x0
    addi t0, x0, -2048
loop_start:
    bge t1, a1, loop_end
    slli t2, t1, 2  
    add t3, a0, t2
    lw t4, 0(t3)
    bge t0, t4, loop_continue
    mv t0, t4
    mv t5, t1
loop_continue:
    addi t1, t1, 1
    j loop_start
error:
    addi a0, x0, 17
    addi a1, x0, 77
    ecall
loop_end:
    # Epilogue
    mv a0, t5
    ret
