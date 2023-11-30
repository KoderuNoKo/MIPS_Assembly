.data 
prompta: .asciiz "Input a: "
promptb: .asciiz "Input b: "
prompt_error: .asciiz "Both a and b must be positive!\n"
print_gcd: .asciiz "GCD = "
print_lcm: .asciiz "LCM = "
newline: .asciiz "\n"

.text
main:
    input:
    li $v0, 4
    la $a0, prompta
    syscall
    li $v0, 5
    syscall
    sle $t0, $v0, $zero
    move $t2, $v0
    
    li $v0, 4
    la $a0, promptb
    syscall
    li $v0, 5
    syscall
    sle $t1, $v0, $zero
    move $t3, $v0
    
    # if a or b is negative, input again
    or $t0, $t0, $t1
    beq $t0, 0, end_input
    li $v0, 4
    la $a0, prompt_error
    syscall
    j input
    
    end_input:
    
    # print GCD
    li $v0, 4
    la $a0, print_gcd
    syscall
    jal GCD
    move $a0, $v0
    move $t6, $v0 # save GCD
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    
    # print LCM
    li $v0, 4
    la $a0, print_lcm
    syscall
    jal LCM
    move $a0, $v0
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    li $v0, 10
    syscall
    
    GCD:
    addi $sp, $sp, -12	# adjust stack for 3 item
    sw $ra, 0($sp)	# save return address
    sw $t2, 4($sp)	# save argument 1 (a)
    sw $t3, 8($sp)	# save argument 2 (b)
    bnez $t3, GCD_return	# check if b == 0 ?
    
    # if so, result is a 
    move $v0, $t2
    lw $ra, 0($sp)
    addi $sp, $sp, 12	# pop 3 item from stack
    jr $ra		# and return
    
    GCD_return:
        # call recursive
        move $t4, $t2
        move $t2, $t3 
        rem $t3, $t4, $t3
        jal GCD
        # restore
        lw $ra, 0($sp)	# return address
        lw $t2, 4($sp)	# restore argument 1
        lw $t3, 8($sp)	# restore argument 2
        addi $sp, $sp, 12	# pop 3 item from stack
        jr $ra		# return 
    
LCM:
    addi $sp, $sp, -8	# adjust stack for 3 item
    sw $t2, 0($sp)	# save argument 1
    sw $t3, 4($sp)	# save argument 2
    
    mul $t5, $t2, $t3	# t5 = (a * b)
    div $v0, $t5, $t6	# result = (a * b) / GCD(a, b)
    
    lw $t2, 0($sp)	# restore argument 1
    lw $t3, 0($sp)	# restore argument 2
    addi $sp, $sp, 8
    jr $ra
    


    
    
