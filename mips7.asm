.data 
    prompt: .asciiz "Input n: "
    promptRes: .asciiz "n! = "
    
.text
main:
    
    # User input n
    li $v0, 4
    la $a0, prompt
    syscall
    li $v0, 5
    syscall
    addi $s0, $v0, 0 # n in $s0
    
    # Calculate
    li $v0, 4
    la $a0, promptRes
    syscall
    
    addi $t0, $zero, 1 # loop counter - multiplier 
    addi $t1, $zero, 1 # factorial
    addi $s0, $s0, 1 # increase n by 1 (loop start at 1)
    loop:
        mul $t1, $t1, $t0
        addi $t0, $t0, 1
        slt $t2, $t0, $s0
        bne $t2, $zero, loop
        
    li $v0, 1
    addi $a0, $t1, 0
    syscall