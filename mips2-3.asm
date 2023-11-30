.data
array: .word 0,0,0,0,0,0,0,0
prompt: .asciiz "Input 7 element:\n"
comma: .asciiz ", "


.text
main:
    li $v0, 4
    la $a0, prompt
    la $s0, array
    syscall
    
    li $t0, 0
    loop_input: # input array
        li $v0, 5
        syscall
        sll $t1, $t0, 2
        add $s1, $s0, $t1
        sw $v0, 0($s1)
        addi $t0, $t0, 1
        bne $t0 ,7, loop_input
        
    li $t0, 0
    loop_process:
        sll $t1, $t0, 2
        add $s1, $s0, $t1
        
        lw $t2, 0($s1)		# t2 is current processing element
        
        bgt $t2, 2, greater_than_2	# if t2 is less than 3, set it to 4
        li $t3, 4
        sw $t3, 0($s1)
        j end_loop_process
        
        greater_than_2:
        rem $t3, $t2, 4
        bne $t3, 0, not_divisable	# if t2 is divisable by 4, divide it by 4
        div $t3, $t2, 4
        sw $t3, 0($s1)
        j end_loop_process
        
        not_divisable:
        
        
        div $t3, $t2, 4		# t3 = t2 / 4
        mul $t4, $t3, 4		# t4 = t3 * 4
        addi $t3, $t3, 1
        mul $t5, $t3, 4		# t5 = (t3 + 1) * 4
        
        sub $t6, $t2, $t4	# t6 = |t3*4 - t2|
        sub $t7, $t5, $t2	# t7 = |(t3 + 1)*4 - t2|
        
        blt $t7, $t6, else
        sw $t4, 0($s1)		# if (t6 <= t7) element is round down
        j end_loop_process
        else:
            sw $t5, 0($s1)	# else it's rounded up
        
        end_loop_process:
        addi $t0, $t0, 1
        bne $t0, 7, loop_process
        
    li $t0, 0
    loop_print:
        sll $t1, $t0, 2
        add $s1, $s0, $t1
        
        li $v0, 1
        lw $a0, 0($s1)
        syscall
        li $v0, 4
        la $a0, comma
        syscall
        
        addi $t0 ,$t0, 1
        bne $t0, 6, loop_print
    
    li $v0, 1    
    lw $a0, 24($s0)
    syscall
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
