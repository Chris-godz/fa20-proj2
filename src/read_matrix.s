.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:
    # Prologue
    addi sp, sp, -36
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw ra, 32(sp)
    mv s0, a0
    mv s1, a1
    mv s2, a2

    # fopen
    mv a1, s0
    add a2, x0, x0 
    jal fopen
    addi t0, x0, -1
    beq a0, t0, fopen_error
    mv s4, a0

    # fread 
    mv a1, s4
    mv a2, s1
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, fread_error

    mv a1, s4
    mv a2, s2
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, fread_error

    # malloc
    lw t1, 0(s1)
    lw t2, 0(s2)
    mul a0, t1, t2
    mv s5, a0
    slli a0, a0, 2
    jal malloc 
    beq a0, x0, malloc_error
    mv s6, a0

    li s7, 0 # i th
    mv s3, s6 
loop_begin:
    bge s7, s5, loop_end

	mv a1, s4
    mv a2, s3
    li a3, 4
    jal fread
    li t0, 4
    bne t0, a0, fread_error
    addi s7, s7, 1
    addi s3, s3, 4 # pointer + 4
    j loop_begin

loop_end:

    # fclose
    mv a1, s4
    jal fclose
    bne a0, x0, flose_error

    # Epilogue
    mv a0, s6
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw ra, 32(sp)
    addi sp, sp, 36
    ret
malloc_error:
    li a1, 88 
    jal exit2
fopen_error:
    li a1, 90
    jal exit2
fread_error:
    li a1, 91
    jal exit2
flose_error:
    li a1, 92 
    jal exit2
