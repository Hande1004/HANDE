.data       
test_data:.word 0x00000000 # Placeholder for input data

.text
.globl my_clz
my_clz:
    li      t0, 0          # Initialize count to 0
    li      t1, 31         # Start from bit 31 (for 32-bit integer)

clz_loop:
    la      t4, test_data  # Load address of test_data into t4
    lw      t4, 0(t4)      # Load the value of test_data into t4
    li      t2, 0          # Set t2 to 0 for comparison
    blt     t1, t2, clz_end # If bit index < 0, exit loop
    li      t3, 1          # Store integer 1 into t3
    sll     t3, t3, t1     # Shift left t3 by t1 
    and     t2, t4, t3     # Checking if bit t1 is set
    bnez    t2, clz_end    # If t2 is non-zero, break the loop (found a set bit)
    addi    t0, t0, 1      # Increment count (leading zero count)
    addi    t1, t1, -1     # Decrement bit index
    j       clz_loop       # Jump back to start of loop

clz_end:
    mv      a0, t0         # Move count to a0 for return
    li      a7, 1          # System call for printing an integer 
    ecall                  # Make the system call to print the value
    li      a7, 10         # System call for exit
    ecall                  # Make the system call to exit the program             # Return from function
