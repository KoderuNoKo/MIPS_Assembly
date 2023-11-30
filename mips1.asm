#request:
.data
prompt1: .asciiz "ENTER THE 1ST NUM: "
prompt2: .asciiz "ENTER THE 2ND NUM: "
promptOp: .asciiz "CHOOSE OPERATOR (+, -, *, /): "
message: .asciiz "\nTHE RESULT IS: "
operator: .word 

.text
 main:
    # Printing out the text
    li $v0, 4
    la $a0, prompt1
    syscall
    # Getting user input 1
    li $v0, 5
    syscall
    # Moving the integer input to another register
    add $t1, $v0, $zero
    
    # repeat the process to get input 2
    li $v0, 4
    la $a0, prompt2
    syscall
    li $v0, 5
    syscall 
    add $t2, $v0, $zero
    
    # Request user input operator
    li $v0, 4
    la $a0, promptOp
    syscall 
    
    # input operator and save to $t0
    li $v0, 12
    la $a0, operator
    syscall
    add $t0, $v0, $zero
    
    # choose operator
    li $t3, '+'
    li $t4, '-'
    li $t5, '*'
    li $t6, '/'
    
    beq $t0, $t3, addlabel
    beq $t0, $t4, sublabel
    beq $t0, $t5, mullabel
    beq $t0, $t6, divlabel
    
    # calculate
    addlabel:
    add $s0, $t1, $t2
    j exit
    sublabel: 
    sub $s0, $t1, $t2
    j exit
    mullabel:
    mul $s0, $t1, $t2
    j exit
    divlabel:
    div $s0, $t1, $t2
    j exit
    
    # result
    exit:
    li $v0, 4
    la $a0, message
    syscall 
    li $v0, 1
    add $a0, $s0, $zero
    syscall
    
    # End Program
    li $v0, 10
    syscall
