.globl relu 

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    # end Prologue
    addi t0, x0, 1
    blt a1, t0, error 
    add t1, x0, x0
loop_start:
    bge t1, a1, loop_end
    slli t2, t1, 2  #offset 
    add t3, a0, t2
    lw t4, 0(t3)
    bge t4, x0, loop_continue
    sw x0, 0(t3)
loop_continue:
    addi t1, t1, 1
    j loop_start
error:
    addi a0, x0, 17
    addi a1, x0, 78
    ecall 
loop_end:
    # Epilogue
    # end Epilogue
	ret
