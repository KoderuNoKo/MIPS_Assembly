.data 
array: .word 1,2,7,7,3,7,4,5,6,7,7,8,8,8,7

prompt: .asciiz "Input 15 element:\n"
comma: .asciiz ", "
res_1: .asciiz "The second largest value is : "
res_2: .asciiz ", found in index "


.text
main:
    la $s0, array
    
    li $v0, 4
    la $a0, prompt
    syscall
    
    li $t0, 0
    loop_input: # input array
        li $v0, 5
        syscall
        sll $t1, $t0, 2
        add $s1, $s0, $t1
        sw $v0, 0($s1)
        addi $t0, $t0, 1
        bne $t0 ,15, loop_input
        
    li $t0, 0    
    li $s2, -2147483648		# s2 store the largest value
    loop_find_max:
        sll $t1, $t0, 2
        add $s1, $s0, $t1
        lw $t2, 0($s1)
        blt $t2, $s2, end_loop_find_max
        move $s2, $t2
        
        end_loop_find_max:
        addi $t0, $t0, 1
        bne $t0, 15, loop_find_max
        
    
    li $t0, 0
    li $t3, -2147483648		# s3 store the second largest value
    loop_find_2nd_max:
        sll $t1, $t0, 2
        add $s1, $s0, $t1
        lw $t2, 0($s1)
        beq $t2, $s2, end_loop_find_2nd_max
        blt $t2, $s3, end_loop_find_2nd_max
        move $s3, $t2
        
        end_loop_find_2nd_max:
        addi $t0, $t0, 1
        bne $t0, 15, loop_find_2nd_max
            
    li $v0 ,4
    la $a0, res_1
    syscall
    li $v0, 1
    move $a0, $s3
    syscall
    li $v0, 4
    la $a0, res_2
    syscall
    
    li $t0, 0
    loop_print:
        sll $t1, $t0, 2
        add $s1, $s0, $t1
        lw $t2, 0($s1)
        bne $t2, $s3, end_loop_print
        li $v0, 1
        move $a0, $t0
        syscall
        li $v0, 4
        la $a0, comma
        syscall
        
        end_loop_print:
        addi $t0, $t0, 1
        bne $t0, 15, loop_print
        
    
    