.data
string: .asciiz "qqqqqqqq"
count_arr: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
comma: .asciiz ", "
newline: .asciiz "\n"


.text
main:
    # count 
    la $t0, string
    li $t1, 0
    la $s0, count_arr
    
    # count each character and store their frequency in the correspoding index in the array
    loop:
        lb $t1, 0($t0)
        beq $t1, $zero, end_loop	# end when read null char
        subi $t1, $t1, 'a'		# t1 is now the index of the array
        sll $t1, $t1, 2			
        add $s0, $s0, $t1		# point s0 to the t1(th) element of the array
        lw $t3, 0($s0)			# get current value in array count, +1 then put it back in
        addi $t3, $t3, 1
        sw $t3, 0($s0)
        sub $s0, $s0, $t1		# bring s0 back to the front of the array
        addi $t0, $t0, 1
        j loop
    end_loop:
    
    # print order
    li $t1, 1 # loop count for outer loop
    la $s1, count_arr
    print_loop_outer:
        li $t2, 0 # loop count for inner loop
        move $s0, $s1
        print_loop_inner:
            lw $t3, 0($s0)
            bne $t3, $t1, end_inner
            
            lw $t4, 0($s0)
            jal print
        end_inner:
            addi $t2, $t2, 1
            addi $s0, $s0, 4
            bne $t2, 26, print_loop_inner
        
        addi $t1, $t1, 1
        bne $t1, 27, print_loop_outer
        
    li $v0, 10
    syscall
    
    print:
        # print char
        li $v0, 11
        move $a0, $t2
        addi $a0, $a0, 'a'
        syscall
        
        # print comma
        li $v0, 4
        la $a0, comma
        syscall
        
        # print freq
        li $v0, 1
        move $a0, $t4
        syscall
        
        # print comma
        li $v0, 4
        la $a0, comma
        syscall
        jr $ra
        
    # print count_arr
    la $t0, count_arr
    li $t1, 0
    li $t2, 26

    print_loop:
        beq $t1, $t2, end_print_loop
        lw $t3, 0($t0)
        move $a0, $t3
        li $v0, 1
        syscall
        li $v0, 11
        li $a0, 32
        syscall
        addi $t0, $t0, 4
        addi $t1, $t1, 1
        j print_loop

    end_print_loop:
    li $v0, 4
    la $a0, newline
    syscall
       
