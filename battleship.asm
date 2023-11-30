# addr = base_addr + (row_idx*col_size + col_idx) * data_size
.data
init1: .asciiz "\nPlayer 1's formation setup. Set coordinates for your ship \"<mode> <cord_x> <cord_y>\"\n"
init2: .asciiz "\nPlayer 2's formation setup. Set coordinates for your ship \"<mode> <cord_x> <cord_y>\"\n"
init_4x1: .asciiz "4x1 ship: "
init_3x1: .asciiz "3x1 ship("
init_2x1: .asciiz "2x1 ship("
init_re: .asciiz "): "
grid_x_axis: .asciiz "  0 1 2 3 4 5 6\n"
clear_grid_prom: .asciiz "Grid cleared!\n"

error_format_prom: .asciiz "\nThe input provided is invalid! Please input in the format \"<mode> <cord_x> <cord_y>\"!\n"
error_format_atk_prom: .asciiz "\nThe input provided is invalid! Please input in the format \"<cord_x> <cord_y>\"!\n"
error_out_of_range_prom: .asciiz "Provided coordinate is out of range! range = [0,6]!\n"
error_mode_prom: .asciiz "Invalid mode provided!\n"
error_obstruct_prom: .asciiz "Can't place ship! It's obstructed\n"

player1_atk_prom: .asciiz "Player1's turn, input coordinate for your attack: "
player2_atk_prom: .asciiz "Player2's turn, input coordinate for your attack: "
hit_prom: .asciiz "HIT!!!\n"
miss_prom: .asciiz "Missed\n"

player1_win_prom: .asciiz "PLAYER1 WINS!!!"
player2_win_prom: .asciiz "PLAYER2 WINS!!!"


newline: .asciiz "\n"
user_input: .space 10
user_atk: .space 5

player1_grid:	.word 0,0,0,0,0,0,0
                .word 0,0,0,0,0,0,0 
                .word 0,0,0,0,0,0,0 
                .word 0,0,0,0,0,0,0 
                .word 0,0,0,0,0,0,0 
                .word 0,0,0,0,0,0,0 
                .word 0,0,0,0,0,0,0 

player2_grid:	.word 1,0,0,0,0,0,0
                .word 0,0,0,0,0,0,0 
                .word 0,0,0,0,0,0,0 
                .word 0,0,0,0,0,0,0 
                .word 0,0,0,0,0,0,0 
                .word 0,0,0,0,0,0,0 
                .word 0,0,0,0,0,0,1 

.text    
main:
    # The player is required to input coordinates of the form "<mode> <cord_x> <cord_y"
    # - one digit each and each seperated by a space
    # where <cord_x> and <cord_y> is the coordinates for the stern of the ship
    # <mode> can be:
    # 	h: horizontal placing
    #	v: vertical placing
    #	c: clear the grid and start placing again
    
    player1_setup:
        li $v0, 4
        la $a0, init1
  	syscall
    
    	la $s0, player1_grid
  	jal print_grid
  	
        player1_4x1:
            li $v0, 4
            la $a0, init_4x1
            syscall

            jal user_input_process
            beqz $v0, player1_4x1
            beq $t0, 'c', clear_player1_grid
        
            la $s0, player1_grid
            li $t3, 4
            jal place_ship
            beqz $v0, player1_4x1
            la $s0, player1_grid
            jal print_grid
            
        li $s1, 1
        loop_player1_3x1: 
            li $v0, 4
            la $a0, init_3x1
            syscall
            li $v0, 1
            move $a0, $s1
            syscall
            li $v0, 4
            la $a0, init_re
            syscall

            jal user_input_process
            beqz $v0, loop_player1_3x1
            beq $t0, 'c', clear_player1_grid
        
            la $s0, player1_grid
            li $t3, 3
            jal place_ship
            beqz $v0, loop_player1_3x1
            la $s0, player1_grid
            jal print_grid
        
        end_loop_player1_3x1:
            addi $s1, $s1, 1
            bne $s1, 3, loop_player1_3x1
            
        li $s1, 1
        loop_player1_2x1:
            li $v0, 4
            la $a0, init_2x1
            syscall
            li $v0, 1
            move $a0, $s1
            syscall
            li $v0, 4
            la $a0, init_re
            syscall

            jal user_input_process
            beqz $v0, loop_player1_2x1
            beq $t0, 'c', clear_player1_grid
        
            la $s0, player1_grid
            li $t3, 2
            jal place_ship
            beqz $v0, loop_player1_2x1
            la $s0, player1_grid
            jal print_grid
            
        end_loop_player1_2x1:
            addi $s1, $s1, 1
            bne $s1, 4, loop_player1_2x1
            
        j player2_setup    
        clear_player1_grid:
            li $v0, 4
            la $a0, clear_grid_prom
            syscall
            la $s0, player1_grid
            jal clear_grid
            j player1_setup
            
    player2_setup:
        li $v0, 4
        la $a0, init2
  	syscall
    
    	la $s0, player2_grid
  	jal print_grid
  	
        player2_4x1:
            li $v0, 4
            la $a0, init_4x1
            syscall

            jal user_input_process
            beqz $v0, player2_4x1
            beq $t0, 'c', clear_player2_grid
        
            la $s0, player2_grid
            li $t3, 4
            jal place_ship
            beqz $v0, player2_4x1
            la $s0, player2_grid
            jal print_grid
            
        li $s1, 1
        loop_player2_3x1: 
            li $v0, 4
            la $a0, init_3x1
            syscall
            li $v0, 1
            move $a0, $s1
            syscall
            li $v0, 4
            la $a0, init_re
            syscall

            jal user_input_process
            beqz $v0, loop_player2_3x1
            beq $t0, 'c', clear_player2_grid
        
            la $s0, player2_grid
            li $t3, 3
            jal place_ship
            beqz $v0, loop_player2_3x1
            la $s0, player2_grid
            jal print_grid
        
        end_loop_player2_3x1:
            addi $s1, $s1, 1
            bne $s1, 3, loop_player2_3x1
            
        li $s1, 1
        loop_player2_2x1:
            li $v0, 4
            la $a0, init_2x1
            syscall
            li $v0, 1
            move $a0, $s1
            syscall
            li $v0, 4
            la $a0, init_re
            syscall

            jal user_input_process
            beqz $v0, loop_player2_2x1
            beq $t0, 'c', clear_player2_grid
        
            la $s0, player2_grid
            li $t3, 2
            jal place_ship
            beqz $v0, loop_player2_2x1
            la $s0, player2_grid
            jal print_grid
            
        end_loop_player2_2x1:
            addi $s1, $s1, 1
            bne $s1, 4, loop_player2_2x1
        
        j end_input
        clear_player2_grid:
            li $v0, 4
            la $a0, clear_grid_prom
            syscall
            la $s0, player2_grid
            jal clear_grid
            j player2_setup
    end_input:
    
    # The player is required to input coordinate for their attack in the format "<cord_x> <cord_y>", 
    # one digit each and each seperated by a space
    # where <cord_x> and <cord_y> are respectively x and y coordinate for the attack
    loop_player_atk:
   	player1_atk:
    	    li $v0, 4
    	    la $a0, player1_atk_prom
    	    syscall
    	    li $v0, 8
    	    la $a0, user_atk
    	    li $a1, 6
    	    syscall
    	    
    	    la $a0, user_atk
    	    jal user_atk_process
    	    beqz $v0, player1_atk
    	    
    	    la $a0, player2_grid
    	    jal atk_handle
    	    beqz $v0, player2_atk
    	    
    	    la $a0, player2_grid
    	    jal is_lost
    	    bnez $v0, player1_win
    	    
    	player2_atk:
    	    li $v0, 4
    	    la $a0, player2_atk_prom
    	    syscall
    	    li $v0, 8
    	    la $a0, user_atk
    	    li $a1, 6
    	    syscall
    	    
    	    la $a0, user_atk
    	    jal user_atk_process
    	    beqz $v0, player2_atk
    	    
    	    la $a0, player1_grid
    	    jal atk_handle
    	    beqz $v0, player1_atk
    	    
    	    la $a0, player1_grid
    	    jal is_lost
    	    bnez $v0, player2_win
    	    
    	    j loop_player_atk
    	    
    	player1_win:
    	    li $v0, 4
    	    la $a0, player1_win_prom
    	    syscall
    	    j end_main
    	    
    	player2_win:
    	    li $v0, 4
    	    la $a0, player2_win_prom
    	    syscall
    	    j end_main
        
    end_main: 
    	li $v0, 10
    	syscall
     
     
user_input_process:	# bool user_input_process(const char* $s0, mode& $t0, cord_x $t1, cord_y $t2) 
			# mode return -1 if invalid input
    addi $sp, $sp, -4
    sw $s0, 0($sp)
    
    li $v0, 8
    li $a1, 10
    la $a0, user_input
    syscall
    la $s0, user_input
    
    lb $t0, 0($s0)
    beq $t0, 'c', end_user_input_process
    beq $t0, 'h', set_coordinate
    beq $t0, 'v', set_coordinate
    j error_mode

    set_coordinate:
    lb $t1, 1($s0)
    bne $t1, ' ', error_format
    lb $t1, 3($s0)
    bne $t1, ' ', error_format
    lb $t1, 5($s0)
    bne $t1, '\n', error_format
    
    lb $t1, 2($s0)
    subi $t1, $t1, 48
    bgt $t1, 6, error_out_of_range
    blt $t1, 0, error_out_of_range
    
    lb $t2, 4($s0)
    subi $t2, $t2, 48
    bgt $t2, 6, error_out_of_range
    blt $t2, 0, error_out_of_range
    li $v0, 1
    j end_user_input_process
    
    error_format:
        li $v0, 4
        la $a0, error_format_prom
        syscall
        li $v0, 0
        j end_user_input_process
        
    error_out_of_range:
        li $v0, 4
        la $a0, error_out_of_range_prom
        syscall
        li $v0, 0
        j end_user_input_process
        
    error_mode:
        li $v0, 4
        la $a0, error_mode_prom
        syscall
        li $v0, 0
        j end_user_input_process
        
    end_user_input_process:
        lw $s0, 0($sp)
        addi $sp, $sp, 4
        jr $ra
        
print_grid:			# void print_grid() - $s0: grid
    addi $sp, $sp, -8
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    
    li $v0, 4
    la $a0, grid_x_axis
    syscall
    li $t0, 0			# t0: loop count for outer loop
    loop_print_grid_outer:
        li $t1, 0		# t1: loop count for inner loop
        
        li $v0, 1
        move $a0, $t0
        syscall
        
        loop_print_grid_inner:
            li $v0, 11
            li $a0, 32
            syscall
            
            mul $t2, $t0, 7	# t2 = row_idx * col_size
            add $t2, $t2, $t1	# t2 = row_idx*col_size + col_idx
            sll $t2, $t2, 2	# t2 = (row_idx*col_size + col_idx) * 4: index of the 2d array
            add $s1, $t2, $s0
            lw $a0, 0($s1)	# a0: the current element to be printed
            li $v0, 1
            syscall
            
        end_loop_print_grid_inner:
            addi $t1, $t1, 1
            bne $t1, 7, loop_print_grid_inner
            
    end_loop_print_grid_outer:
        li $v0, 4
        la $a0, newline
        syscall

        addi $t0, $t0, 1
        bne $t0, 7, loop_print_grid_outer
        
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    addi $sp, $sp, 8
    jr $ra
            
place_ship:	# bool place_ship(grid& $s0, mode $t0, cord_x $t1, cord_y $t2, ship_type $t3)
		# function return 'false' in $v0 if ship placing failed and return 'true' otherwise
    addi $sp, $sp, -8
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    
    bne $t0, 'h', vertical_mode
    horizontal_mode:
    	# check if out of grid
    	add $t4, $t1, $t3		# t4 = cord_x + ship_type
    	bge $t4, 8, error_obstruct
    	
    	# check if overlap
    	move $t0, $t1			# t0 = cord_x
    	loop_check_overlap_h:
    	    mul $t5, $t2, 7
    	    add $t5, $t5, $t0
    	    sll $t5, $t5, 2
    	    add $s1, $s0, $t5		# t5 = current index
    	    lw $t6, 0($s1)		# t6 current element
    	    bnez $t6, error_obstruct
    	    
    	end_loop_check_overlap_h:
    	    addi $t0, $t0, 1
    	    blt $t0, $t4, loop_check_overlap_h
    	    
    	# place ship
    	li $t6, 1	# hold 1 to store into array
    	move $t0, $t1	# loop count
	loop_place_h:
            mul $t5, $t2, 7
    	    add $t5, $t5, $t0
    	    sll $t5, $t5, 2
    	    add $s1, $s0, $t5		# t5 = current index
    	    sw $t6, 0($s1)
    	    
    	    addi $t0, $t0, 1
    	    blt $t0, $t4, loop_place_h
    	    li $v0, 1
    	    j end_place_ship
    	    
    vertical_mode:
        # check if out of range
        add $t4, $t2, $t3
        bge $t4, 8, error_obstruct
    	
    	# check if overlap
    	move $t0, $t2
    	loop_check_overlap_v:
    	    mul $t5, $t0, 7
    	    add $t5, $t5, $t1
    	    sll $t5, $t5, 2
    	    add $s1, $s0, $t5
    	    lw $t6, 0($s1)
    	    bnez $t6, error_obstruct
    	    
    	end_loop_check_overlap_v:
    	    addi $t0, $t0, 1
    	    blt $t0, $t4, loop_check_overlap_v
    	    
    	# place ship
    	move $t0, $t2		# t0 = cord_y: loop count
    	li $t6, 1
    	loop_place_v:
    	    mul $t5, $t0, 7
    	    add $t5, $t5, $t1
    	    sll $t5, $t5, 2
    	    add $s1, $s0, $t5
    	    sw $t6, 0($s1)
    	    
    	    addi $t0, $t0, 1
    	    blt $t0, $t4, loop_place_v
    	    li $v0, 1
    	    j end_place_ship
    	
    error_obstruct:
        li $v0, 4
        la $a0, error_obstruct_prom
        syscall
        li $v0, 0
        j end_place_ship
        
    end_place_ship:
    	lw $s0, 0($sp)
    	lw $s1, 4($sp)
    	addi $sp, $sp, 8
    	jr $ra
        
clear_grid:	# void clear(grid& $s0)
    addi $sp, $sp, -8
    sw $s0, 0($sp)
    sw $s0, 4($sp)
    
    li $t0, 0			# t0: loop count for outer loop
    loop_clear_grid_outer:
        li $t1, 0		# t1: loop count for inner loop
        
        loop_clear_grid_inner:
            mul $t2, $t0, 7	# t2 = row_idx * col_size
            add $t2, $t2, $t1	# t2 = row_idx*col_size + col_idx
            sll $t2, $t2, 2	# t2 = (row_idx*col_size + col_idx) * 4: index of the 2d array
            add $s1, $t2, $s0
            sw $zero, 0($s1)
            
        end_clear_print_grid_inner:
            addi $t1, $t1, 1
            bne $t1, 7, loop_clear_grid_inner
            
    end_loop_clear_grid_outer:
        addi $t0, $t0, 1
        bne $t0, 7, loop_clear_grid_outer
        
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    addi $sp, $sp, 8
    jr $ra

user_atk_process:		# bool user_input_process(string $a0, cord_x& $t0, cord_y& $t1)
				# the function return 'false' in $v0 if invalid input and return 'true' otherwise
     lb $t0, 1($a0)
     bne $t0, ' ', error_atk_format
     lb $t0, 3($a0)
     bne $t0, '\n', error_atk_format
     
     lb $t0, 0($a0)
     subi $t0, $t0, 48
     bgt $t0, 6, error_atk_out_of_range
     blt $t0, 0, error_atk_out_of_range
     
     lb $t1, 2($a0)
     subi $t1, $t1, 48
     bgt $t1, 6, error_atk_out_of_range
     blt $t1, 0, error_atk_out_of_range 
     
     li $v0, 1
     j end_user_atk_process
     error_atk_format:
         li $v0, 4
         la $a0, error_format_atk_prom
         syscall
         li $v0, 0
         j end_user_atk_process
         
     error_atk_out_of_range:
         li $v0, 4
         la $a0, error_out_of_range_prom
         syscall
         li $v0, 0
         j end_user_atk_process
         
     end_user_atk_process:
         jr $ra
         
atk_handle:		# bool atk_handle(target_grid $a0, cord_x $t0, cord_y $t1)
			# the function return 'true' in $v0 if it's a hit, else return 'false'
    addi $sp, $sp, -4
    sw $s1, 0($sp)
    
    mul $t2, $t1, 7	
    add $t2, $t2, $t0
    sll $t2, $t2, 2	# t2: target idx for the array
    add $s1, $a0, $t2
    lw $t2, 0($s1)	# t2: target value
    beqz $t2, atk_missed
    
    li $v0, 4
    la $a0, hit_prom
    syscall
    li $t2, 0
    sw $t2, 0($s1)
    li $v0, 1
    j end_atk_handle
    
    atk_missed:
        li $v0, 4
        la $a0, miss_prom
        syscall
        li $v0, 0
        j end_atk_handle
        
    end_atk_handle:
    	lw $s1, 0($sp)
    	addi $sp, $sp, 4
    	jr $ra
    	
is_lost:	# bool(grid $a0)
		# the function return 'true' in $v0 if the grid is completely cleared, else return 'false'
    addi $sp, $sp, -4
    sw $s1, 0($sp)
    
    li $t0, 0			# t0: outer loop count 
    loop_scan_grid_outer:
        li $t1, 0		# t1: inner loop count
        loop_scan_grid_inner:
            mul $t2, $t0, 7
            add $t2, $t2, $t1
            sll $t2, $t2, 2
            add $s1, $a0, $t2
            lw $t2, 0($s1)
            bne $t2, 0, con_cuu_dc
            
            addi $t1, $t1, 1
            bne $t1, 7, loop_scan_grid_inner
            
        end_loop_scan_grid_outer:
            addi $t0, $t0, 1
            bne $t0, 7, loop_scan_grid_outer
            
    het_cuu:
        li $v0, 1
        j end_is_lost
        
    con_cuu_dc:
        li $v0, 0
        j end_is_lost
        
    end_is_lost:
        lw $s1, 0($sp)
        addi $sp, $sp, 4
        jr $ra
        
        

