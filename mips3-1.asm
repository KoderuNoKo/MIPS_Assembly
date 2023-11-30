.data
pi: .float 3.14159265359
two: .float 2.0
three: .float 3.0
six: .float 6.0
metric: .space 5

metric_prom: .asciiz "What is your metric: "
prom: .asciiz "1. Rectangular box\n2. Cube\n3. Pyramid\n4. Prism\n5. Sphere\nSelect a shape to calculate: "
rec_prom: .asciiz "Input 3 parameters for the rectangular box:\n"
cube_prom: .asciiz "Input the length for the edges:\n"
pyramid_prom: .asciiz "Input 3 parameters (height, base width) for the pyramid:\n"
prism_prom: .asciiz "Input 4 parameters (height, 3 parameter for the base triangle) for the prism:\n"
sphere_prom: .asciiz "Input the radius for the sphere:\n"

parameters: .float 0,0,0

vol_prom: .asciiz "V = "
sur_prom: .asciiz "S = "
newline: .asciiz "\n"


.text
main:
    li $v0, 4
    la $a0, metric_prom
    syscall

    li $v0, 8
    la $a0, metric
    li $a1, 5
    syscall

    li $v0, 4
    la $a0, prom
    syscall
    
    li $v0, 5
    syscall
    la $s0, parameters
    
    beq $v0, 1, box
    beq $v0, 2, cube
    beq $v0, 3, pyramid
    beq $v0, 4, prism
    beq $v0, 5, sphere
    
    box:
    	li $v0, 4
    	la $a0, rec_prom
    	syscall
    
        li $t0, 0
        loop_box_input:
            li $v0, 6
            syscall
            sll $t1, $t0, 2
            add $s1, $s0, $t1
            s.s $f0, 0($s1)
            
        end_loop_box_input:
            addi $t0, $t0, 1
            bne $t0, 3, loop_box_input
            
	l.s $f2, 0($s0)	# a
        l.s $f3, 4($s0)	# b
        l.s $f4, 8($s0)	# c
        
        # calculate volume
        mul.s $f5, $f2, $f3
        mul.s $f5, $f5, $f4
        
        # calculate surface area
        li $v0, 2
        add.s $f6, $f2, $f3	# f6 = a + b
        mul.s $f6, $f6, $f4	# f6 = (a + b) * c
        mul.s $f7, $f2, $f3	# f7 = a * b
        add.s $f6, $f6, $f7	# f6 = (a + b)*c + a*b
        l.s $f7, two
        mul.s $f6, $f6, $f7

        j print_result
        
    cube:
    	li $v0, 4
    	la $a0, cube_prom
    	syscall
    	
    	li $v0, 6
    	syscall
    	
    	# volume
    	mul.s $f5, $f0, $f0
    	mul.s $f5, $f5, $f0
    	
    	# surface
    	mul.s $f6, $f0, $f0
    	l.s $f0, six
    	mul.s $f6, $f6, $f0
    	
    	j print_result
    	
    pyramid:
        li $v0, 4
        la $a0, pyramid_prom
        syscall
        
	li $t0, 0
        loop_pyr_input:
            li $v0, 6
            syscall
            sll $t1, $t0, 2
            add $s1, $s0, $t1
            s.s $f0, 0($s1)
            
        end_loop_pyr_input:
            addi $t0, $t0, 1
            bne $t0, 2, loop_pyr_input
            
	l.s $f2, 0($s0)	# height
        l.s $f3, 4($s0)	# a
        
	# volume
	mul.s $f5, $f2, $f3
	mul.s $f5, $f5, $f3
	l.s $f1, three
	div.s $f5, $f5, $f1
	
	# surface
    	mul.s $f4, $f2, $f2 # f4 = h^2
    	l.s $f1, two
    	div.s $f7, $f3, $f1 
    	div.s $f7, $f7, $f7 # f7 = (a/2)^2
    	add.s $f4, $f4, $f7
    	sqrt.s $f4, $f4     # f4: slant
    
    	add.s $f1, $f1, $f1
    	mul.s $f7, $f3, $f1 # f7: base circum
    	mul.s $f6, $f7, $f4
    	l.s $f1, two
    	div.s $f6, $f6, $f1 # f6 = 1/2 * slant * base circum
    	mul.s $f7, $f3, $f3 # f7: base area
    	add.s $f6, $f6, $f7

	j print_result


    prism:
        li $v0, 4
        la $a0, prism_prom
        syscall
        
	li $t0, 0
        loop_prism_input:
            li $v0, 6
            syscall
            sll $t1, $t0, 2
            add $s1, $s0, $t1
            s.s $f0, 0($s1)
            
        end_loop_prism_input:
            addi $t0, $t0, 1
            bne $t0, 4, loop_prism_input
            
	l.s $f2, 0($s0)		# height
	l.s $f3, 4($s0)  	# base a
	l.s $f4, 8($s0) 	# base b
	l.s $f7, 12($s0)   	# base c
        
        # volume
        add.s $f8, $f3, $f4
        add.s $f8, $f8, $f7
        l.s $f1, two
        div.s $f8, $f8, $f1 # f8 = p

        sub.s $f1, $f8, $f3 # p - a
        mul.s $f9, $f8, $f1 # p(p - a)  
        sub.s $f1, $f8, $f4 # p - b
        mul.s $f9, $f9, $f1
        sub.s $f1, $f8, $f7 # p - c
        mul.s $f9, $f9, $f1 # p(p - a)(p - b)(p - c)
        sqrt.s $f9, $f9     # f9: base area

        mul.s $f5, $f9, $f2

        # surface
        add.s $f8, $f3, $f4
        add.s $f8, $f8, $f7 # f8: base circum
        mul.s $f6, $f8, $f2
        add.s $f9, $f9, $f9
        add.s $f6, $f6, $f9
        
        j print_result
    
    sphere:
    	li $v0, 4
    	la $a0, sphere_prom
    	syscall
    	
    	li $v0, 6
    	syscall
    	
    	# volume
    	mul.s $f5, $f0, $f0
    	mul.s $f5, $f5, $f0
    	l.s $f1, two
    	mul.s $f1, $f1, $f1
    	mul.s $f5, $f5, $f1
    	l.s $f1, three
    	div.s $f5, $f5, $f1
    	l.s $f1, pi
    	mul.s $f5, $f5, $f1
    	
        # surface
        mul.s $f6, $f0, $f0
        l.s $f1, two
        mul.s $f1, $f1, $f1
        mul.s $f6, $f6, $f1
        l.s $f1, pi
        mul.s $f6, $f6, $f1
        
        j print_result

    print_result:
        # volume
        li $v0, 4
        la $a0, vol_prom
        syscall
        li $v0, 2
        mov.s $f12, $f5
        syscall
                
        li $v0, 11
        li $a0, 32
        syscall
        la $v0, 4
        la $a0, metric
        syscall
        li $v0, 1
        li $a0, 3
        syscall
        
        li $v0, 4
        la $a0, newline
        syscall

        # surface
        li $v0, 4
        la $a0, sur_prom
        syscall
        li $v0, 2
        mov.s $f12, $f6
        syscall

        li $v0, 11
        li $a0, 32
        syscall
        la $v0, 4
        la $a0, metric
        syscall
        li $v0, 1
        li $a0, 2
        syscall