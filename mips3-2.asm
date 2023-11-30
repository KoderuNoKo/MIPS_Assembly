# 2252394
.data
input_prom:.asciiz "Insert a, b, c, d, u and v:\n"
output_prom: .asciiz "The result is "
parameters: .float 0,0,0,0,0,0
five: .float 5.0
four: .float 4.0
three: .float 3.0
two: .float 2.0
one: .float 1.0
zero: .float 0.0

.text
main:
    li $v0, 4
    la $a0, input_prom
    syscall

    la $s0, parameters
    li $t0, 0
    loop_insert:
        sll $t1, $t0, 2
        add $s1, $s0, $t1
	li $v0, 6
        syscall
        s.s $f0, 0($s1)
        
    end_loop_insert:
        addi $t0, $t0, 1
        bne $t0, 6, loop_insert
        
    # upper
    l.s $f2, 0($s0) 		# f2: a
    l.s $f3, five		# f3: 5
    div.s $f2, $f2, $f3 	# f2: a/5
    l.s $f0, 16($s0)		# f0: u
    li $a0, 5			
    jal power			# f1: u^5
    mul.s $f5, $f1, $f2		# f5 a/5*u^5
        
    l.s $f2, 4($s0) 
    l.s $f3, four
    div.s $f2, $f2, $f3 
    l.s $f0, 16($s0)
    li $a0, 4
    jal power
    mul.s $f6, $f1, $f2
    add.s $f5, $f5, $f6
        
    l.s $f2, 8($s0) 
    l.s $f3, three
    div.s $f2, $f2, $f3 
    l.s $f0, 16($s0)
    li $a0, 3
    jal power
    mul.s $f6, $f1, $f2
    add.s $f5, $f5, $f6
    
    l.s $f2, 12($s0)  
    l.s $f0, 16($s0)
    mul.s $f6, $f0, $f2
    add.s $f5, $f5, $f6
    
    # lower
    l.s $f2, 0($s0) 
    l.s $f3, five
    div.s $f2, $f2, $f3 
    l.s $f0, 20($s0)
    li $a0, 5
    jal power
    mul.s $f10, $f1, $f2
        
    l.s $f2, 4($s0) 
    l.s $f3, four
    div.s $f2, $f2, $f3 
    l.s $f0, 20($s0)
    li $a0, 4
    jal power
    mul.s $f6, $f1, $f2
    add.s $f10, $f10, $f6
    
    l.s $f2, 8($s0) 
    l.s $f3, three
    div.s $f2, $f2, $f3 
    l.s $f0, 20($s0)
    li $a0, 3
    jal power
    mul.s $f6, $f1, $f2
    add.s $f10, $f10, $f6
    
    l.s $f2, 12($s0)  
    l.s $f0, 20($s0)
    mul.s $f6, $f0, $f2
    add.s $f10, $f10, $f6
        
    # final
    li $v0, 4
    la $a0, output_prom
    syscall
    
    sub.s $f12, $f5, $f10
    l.s $f1, four
    mul.s $f1, $f1, $f1
    div.s $f12, $f12, $f1
    li $v0, 2
    syscall
    
    li $v0, 10
    syscall
    
power:		# $f1 power(float $f0, int $a0)
    li $t0, 0
    l.s $f1, one
    loop_power:
        mul.s $f1, $f1, $f0
        addi $t0, $t0, 1
        bne $t0, $a0, loop_power
        
    jr $ra
