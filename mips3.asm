.data
prompt: .asciiz "Select mode: \n1. Print the value of the element chosen \n2. Print a sequence of values from the elements chosen\n"
promptM1: .asciiz "Index: "
promptM2_f: .asciiz "From: "
promptM2_t: .asciiz "To: "
space: .asciiz ", "

array: .word 4, 5, 7, 8, 9, 7, 4, 8, 7, 14, 4, 57, 45, 74, 41

.text
main:
    la $s0, array
    # Printing out the text
    li $v0, 4
    la $a0, prompt
    syscall
    
    # Input option
    li $v0, 5
    syscall
    li $t0, 1
    beq $v0, $t0, option1
    li $t0, 2
    beq $v0, $t0, option2
    j exit 
    
    option1:
    # Printing out the text
    li $v0, 4
    la $a0, promptM1
    syscall
    
    # User input index
    li $v0, 5
    syscall
    
    # Get the nth index
    sll $t0, $v0, 2
    add $s1, $s0, $t0
    lw $a0, 0($s1)
    li $v0, 1
    syscall  
    
 
 
    option2:
    # Input range
    li $v0, 4
    la $a0, promptM2_f # From ($t0)
    syscall
    li $v0, 5
    syscall
    sll $t0, $v0, 2
    li $v0, 4
    la $a0, promptM2_t # To ($t1)
    syscall
    li $v0, 5
    syscall
    sll $t1, $v0, 2
    
    # Get sequence
    
    loop:
    li $v0, 1
    add $s1, $s0, $t0
    lw $a0, 0($s1)
    syscall
    li $v0, 4
    la $a0, space
    syscall
    addi $t0, $t0, 4
    bne $t0, $t1, loop
    
    li $v0, 1
    add $s1, $s0, $t1
    lw $a0, 0($s1)
    syscall


    exit: