.data
argument: .word 0x00000000      # Placeholder for input float value 
.text
.globl fabsf
fabsf:
    # Load the input float value from memory
    la      t0, argument        # Load address of argument into t0
    lw      t1, 0(t0)           # Load the bits of the float into t1 
    li      t2, 0x7FFFFFFF      # Load mask to clear the sign bit into t2 
    and     t1, t1, t2          # Get the absolute value of the float
            
    # Return the modified value
    mv      a0, t1              # Move the result to a0 
    li      a7, 2               # System call for printing an float 
    ecall                       # Make the system call to print the value                         # Return from the function
