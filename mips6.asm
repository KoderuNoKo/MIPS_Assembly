.data
    binary: .space 11
    prompt: .asciiz "Enter 10-bit binary number: "
    promptRes: .asciiz "\nThe equivalent decimal value is: "
    space: .asciiz "\n"
.text
main:
    # Prompt
    li $v0, 4
    la $a0, prompt
    syscall
    
    # Input user string
    li $v0, 8
    la $a0, binary
    li $a1, 12
    syscall
    
    # Convert to decimal
    addi $s0, $zero, 0 # result
    li $v0, 1
    loop:
        lbu $t0, 0($a0)
        beq $t0, '\n', end_loop # end of string 
        
        subi $t0, $t0, '0' # translate char to int
        sll $s0, $s0, 1
        add $s0, $s0, $t0
        addi $a0, $a0, 1
        addi $t0, $a0, 0
        
        j loop
     
     end_loop:
     # Print result 
     li $v0, 4
     la $a0, space
     syscall
     li $v0, 1
     addi $a0, $s0, 0
     syscall     