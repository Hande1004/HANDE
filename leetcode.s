.data
.align 2
test_value1:   .word 8       # Define test value 1 (8)
.align 2
test_value2:   .word 531     # Define test value 2 (531)
.align 2
test_value3:   .word 1000    # Define test value 3 (1000)
.align 2
prompt_msg:    .string "testing three integers 8,531,1000 "  # Prompt message to display
.align 2
left_parenthesis:     .string "["  # Left parenthesis for result display
.align 2
right_parenthesis:    .string "]"  # Right parenthesis for result display
.align 2
comma_space:   .string ", "  # Comma and space separator
.align 2
newline:       .string "\n"  # Newline character
.text
.globl main
main:
    # Prompt for input
    la      a0, prompt_msg     # Load address of prompt message
    li      a7, 4              # System call for print string (uses a0 for address)
    ecall                      # Print the prompt
    la      a0, newline        # Load address of newline
    li      a7, 4              # System call for print string
    ecall                      # Print newline

process_input1:
    # Test value 1: Set input value to 8
    la      t0, test_value1    # Load address of test_value1
    lw      t0, 0(t0)          # Load value of test_value1 into t0
    li      t6, 0              # Set t6 to 0 to indicate the first test case
    j       even_loop_arg      # Jump to the even loop argument initialization

process_input2:
    # Test value 2: Set input value to 531
    li      t6, 1              # Set t6 to 1 to indicate the second test case
    la      t0, test_value2    # Load address of test_value2
    lw      t0, 0(t0)          # Load value of test_value2 into t0
    j       even_loop_arg      # Jump to the even loop argument initialization

process_input3:
    # Test value 3: Set input value to 1000
    li      t6, 2              # Set t6 to 2 to indicate the third test case
    la      t0, test_value3    # Load address of test_value3
    lw      t0, 0(t0)          # Load value of test_value3 into t0
    j       even_loop_arg      # Jump to the even loop argument initialization

even_loop_arg:
    li      t1, 0              # t1 will hold the even count, initialize to 0
    li      t2, 0              # Start with bit index 0

even_loop:
    li      t4, 9              # Set upper limit for even index to 9
    bge     t2, t4, odd_loop   # If index >= 9, move to odd count
    li      t3, 1              # Load 1 into t3 for bitwise shifting
    sll     t3, t3, t2         # t3 = 1 << t2 (1 shifted by t2 positions)
    and     t4, t0, t3         # t4 = t0 & (1 << t2), check if bit at position t2 is 1
    beqz    t4, skip_even_inc  # If t4 == 0, skip increment of even count
    addi    t1, t1, 1          # Increment even count

skip_even_inc:
    addi    t2, t2, 2          # Increment index by 2 to move to the next even bit
    j       even_loop          # Repeat even loop

    # Calculate number of 1s at odd indices
odd_loop:
    li      t2, 1              # Start with bit index 1 for odd bits
    li      t5, 0              # t5 will hold the odd count, initialize to 0

odd_loop_inner:
    li      t4, 10             # Set upper limit for odd index to 10
    bge     t2, t4, print_result # If index >= 10, move to printing result
    li      t3, 1              # Load 1 into t3 for bitwise shifting
    sll     t3, t3, t2         # t3 = 1 << t2 (1 shifted by t2 positions)
    and     t4, t0, t3         # t4 = t0 & (1 << t2), check if bit at position t2 is 1
    beqz    t4, skip_odd_inc   # If t4 == 0, skip increment of odd count
    addi    t5, t5, 1          # Increment odd count

skip_odd_inc:
    addi    t2, t2, 2          # Increment index by 2 to move to the next odd bit
    j       odd_loop_inner     # Repeat odd loop

print_result:
    # Print result [even, odd]
    la      a0, left_parenthesis # Load address of left parenthesis
    li      a7, 4              # System call for print string
    ecall                      # Print left parenthesis
    
    mv      a0, t1             # Move even count to a0
    li      a7, 1              # System call number 1 for printing an integer (a0 contains the value to print)
    ecall                      # Print even count

    la      a0, comma_space    # Load address of comma and space
    li      a7, 4              # System call for print string
    ecall                      # Print comma and space

    mv      a0, t5             # Move odd count to a0
    li      a7, 1              # System call for print integer
    ecall                      # Print odd count

    la      a0, right_parenthesis # Load address of right parenthesis
    li      a7, 4              # System call for print string
    ecall                      # Print right parenthesis
    
    la      a0, newline        # Load address of newline
    li      a7, 4              # System call for print string
    ecall                      # Print newline
    
    li      t2, 0              # Set t2 to 0 to check the current test case
    beq     t6, t2, process_input2 # If t6 == 0, jump to process_input2
    li      t2, 1              # Set t2 to 1 to check the next test case
    beq     t6, t2, process_input3 # If t6 == 1, jump to process_input3
    
    # Exit
    li      a7, 10             # System call for exit
    ecall                      # Exit the program
