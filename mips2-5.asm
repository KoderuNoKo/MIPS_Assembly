.data
array: .word 1,2,3,3,3,1,100,8,9,100
unique_els: .word 10

unique_print: .asciiz "Unique values: "
duplicate_print: .asciiz "\nDuplicate value: "
duplicate_repeat: .asciiz ", repeated "
duplicate_times: .asciiz " times; "
newline: .asciiz "\n"
.text 
main:
    la $s0, array
    jal bubble_sort
        
    # print unique
    li $v0, 4
    la $a0, unique_print
    syscall
    
    li $t0, 0		# loop count
    lw $t2, 0($s0)	# init element to be printed
    li $t4, 0		# current freq count
    loop_print_unique:
        sll $t1, $t0, 2
        add $s1, $s0, $t1
        lw $t3, 0($s1)	# t3 is the element to be compared with t2
        
        beq $t3, $t2, end_loop_print_unique
        
            bgt $t4, 1, end_print
            li $v0, 1
            move $a0, $t2
            syscall
            li $v0, 11
            li $a0, ','
            syscall
            
        end_print:
            li $t4, 0
            move $t2, $t3
            
    end_loop_print_unique:
        addi $t0, $t0, 1
        addi $t4, $t4, 1
        bne $t0, 10, loop_print_unique
        
        # last element
        bgt $t4, 1, else
        li $v0, 1
        move $a0, $t3
        syscall
        li $v0, 11
        li $a0, '.'
        syscall
        else:
        
        
    # print duplicate
    li $v0, 4
    la $a0, duplicate_print
    syscall
    
    li $t0, 0		# loop count
    lw $t2, 0($s0)	# init element to be printed
    li $t4, 0		# current freq count
    loop_print_duplicate:
        sll $t1, $t0, 2
        add $s1, $s0, $t1
        lw $t3, 0($s1)	# t3 is the element to be compared with t2
        
        beq $t2, $t3, end_loop_print_duplicate
        
        ble $t4, 1, end_print_duplicate
        li $v0, 1
        move $a0, $t2
        syscall
        
        li $v0, 4
        la $a0, duplicate_repeat
        syscall
        
        li $v0, 1
        move $a0, $t4
        syscall
        
        li $v0, 4
        la $a0, duplicate_times
        syscall
        
        end_print_duplicate:
            li $t4, 0
            move $t2, $t3
            
    end_loop_print_duplicate:
        addi $t0, $t0, 1
        addi $t4, $t4, 1
        bne $t0, 10, loop_print_duplicate
        
        # last element
        ble $t4, 1, else_1
        li $v0, 1
        move $a0, $t2
        syscall
        
        li $v0, 4
        la $a0, duplicate_repeat
        syscall
        
        li $v0, 1
        move $a0, $t4
        syscall
        
        li $v0, 4
        la $a0, duplicate_times
        syscall
        else_1:
        
        
        
        
    li $v0, 10
    syscall
    
bubble_sort:
    li $t0, 0		# outer loop count i = 0
    loop_sort_outer:	
        li $t1, 9	# inner loop count j = n - 1
        
        loop_sort_inner:
            subi $t2, $t1, 1
            sll $t2, $t2, 2
            add $s1, $s0, $t2
            lw $t3, 0($s1)	# t3 = array[j - 1]
            lw $t4, 4($s1)	# t4 = array[j]
            ble $t3, $t4, end_loop_sort_inner	# if (t3 <= t4) { dont swap; }
            
            # swap
            sw $t3, 4($s1)
            sw $t4, 0($s1)
            
        end_loop_sort_inner:	# for (j = n - 1; j > i; j--)
            subi $t1, $t1, 1
            bne $t1, $t0, loop_sort_inner
                
    end_loop_sort_outer:	# for (i = 0; i < n - 1; i++)
        addi $t0, $t0, 1
        bne $t0, 9, loop_sort_outer  
        
    jr $ra   
            
