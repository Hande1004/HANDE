#upper code for function fp16_to_fp32
.data
# Define the test data with half-precision floating-point value (16-bit)
testing_data: .word 0x7c00

.text
.globl fp16_to_fp32
fp16_to_fp32:
    # Load the address of testing_data into t1
    la      t1, testing_data
    # Load the value at the address stored in t1
    lw      t1, 0(t1)
    # Shift the 16-bit half-precision value to the upper half of a 32-bit word
    slli    t1, t1, 16
    # Load sign bit mask into t2 (0x80000000)
    li      t2, 0x80000000
    # Isolate the sign bit from the input number (bit 31)
    and     t2, t2, t1
    # Load mask to extract mantissa and exponent (0x7FFFFFFF)
    li      t3, 0x7FFFFFFF
    # Apply the mask to extract the mantissa and exponent from the input value
    and     t3, t3, t1

    # Calculate renorm_shift using my_clz
    # Move value of t3 to a0 for my_clz function call
    mv      a0, t3
    # Call my_clz function to calculate the leading zero count
    jal     ra, my_clz
    # Move the result of my_clz from a0 to t4 (renorm_shift)
    mv      t4, a0

    # Continue with the rest of the code
    li      t5, 5                # Load immediate value 5 to t5
    # If renorm_shift < 5, skip subtracting 5
    blt     t4, t5, skip_renorm
    # If renorm_shift == 5, skip subtracting 5
    beq     t4, t5, skip_renorm
    # renorm_shift = renorm_shift - 5
    sub     t4, t4, t5

skip_renorm:
    # Calculate inf_nan_mask
    li      t6, 0x04000000          # Load value 0x04000000 to t6
    add     t6, t6, t3             # nonsign + 0x04000000
    srai    t6, t6, 8              # Shift right by 8 to adjust for exponent position
    li      a1, 0x7F800000         # Load mask for inf_nan_mask
    and     t6, t6, a1             # Apply mask to calculate inf_nan_mask

    # Calculate zero_mask
    addi    a1, t3, -1             # nonsign - 1
    srai    a1, a1, 31             # Shift right by 31 to propagate bit 31 across all bits

    # Normalize, adjust exponent, apply masks and combine with sign
    sll     t3, t3, t4             # Shift left by renorm_shift
    srli    t3, t3, 3              # Shift right by 3 to adjust exponent and mantissa
    li      a2, 0x70               # Load bias adjustment value 0x70
    sub     a2, a2, t4             # Subtract renorm_shift from exponent bias
    slli    a2, a2, 23             # Shift exponent into the correct position
    add     t3, t3, a2             # Add adjusted exponent to the value
    or      t3, t3, t6             # Combine with inf_nan_mask
    not     a1, a1                 # Invert zero_mask
    and     t3, t3, a1             # Apply inverted zero_mask to clear bits if needed
    or      a0, t2, t3             # Combine with the sign bit to get final result

    # Print the result
    li      a7, 34                 # System call for printing float value
    ecall
    # Exit the program
    li      a7, 10                 # System call for exit
    ecall
#-------------------------------------------------------------------------------#
#lower code for function my_clz
.text
.globl my_clz
my_clz:
    # Initialize count to 0 in t0
    li      t0, 0
    # Start from bit index 31 for 32-bit integer
    li      t5, 31

clz_loop:
    # Load value from a0 to t4 (current input value)
    addi    t4, a0, 0
    # Set t6 to 0 for comparison
    li      t6, 0
    # If bit index < 0, exit loop
    blt     t5, t6, clz_end
    # Set a1 to 1 for masking specific bit
    li      a1, 1
    # Shift left a1 by t5 to create the mask for checking specific bit
    sll     a1, a1, t5
    # AND operation to check if bit t5 is set
    and     t6, t4, a1
    # If bit is set, break loop
    bnez    t6, clz_end
    # Otherwise, increment the leading zero count
    addi    t0, t0, 1
    # Decrement the bit index
    addi    t5, t5, -1
    # Jump back to the start of the loop
    j       clz_loop

clz_end:
    # Move leading zero count to a0 for return
    mv      a0, t0
    # Return from the function
    ret

