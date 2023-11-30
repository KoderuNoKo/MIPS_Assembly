.data 
    promptA: .asciiz "Input N: "
    promptB: .asciiz "Input M: "
    promptC: .asciiz "Input X: "
    prompt: .asciiz "Sequence: "
    space: .asciiz ", "
    
.text
main:
    # input N
    li $v0, 4
    la $a0, promptA
    syscall
    li $v0, 5
    syscall
    addi $s0, $v0, 0 # N in $s0
    
    #input b
    li $v0, 4
    la $a0, promptB
    syscall
    li $v0, 5
    syscall
    addi $s1, $v0, 0 # M in $s1
    
    # input c
    li $v0, 4
    la $a0, promptC
    syscall
    li $v0, 5
    syscall
    addi $s2, $v0, 0 # X in $s2
    
    # Print sequence
    li $v0, 4
    la $a0, prompt
    syscall
    li $v0, 1
    addi $a0, $s0, 0 # print N
    syscall
    li $v0, 4
    la $a0, space
    syscall
    
    li $t1, 1 # multiplier & loop counter - X
    loop:
        mul $s0, $s0, $s1
        li $v0, 1
        addi $a0, $s0, 0 # print Num
        syscall
        
        li $v0, 4
        la $a0, space # print space
        syscall
        
        addi $t1, $t1, 1
        bne $t1, $s2, loop
     endloop:
     
     mul $s0, $s0, $s1
     li $v0, 1
     addi $a0, $s0, 0 # print last Num
     syscall  
        
        
        