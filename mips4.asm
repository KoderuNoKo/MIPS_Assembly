.data 
    promptA: .asciiz "Input a: "
    promptB: .asciiz "Input b: "
    promptC: .asciiz "Input c: "
    promptD: .asciiz "Input d: "
    promptF: .asciiz "F = "
    promptG: .asciiz "\nG = "
    
.text
main:
    # input a
    li $v0, 4
    la $a0, promptA
    syscall
    li $v0, 5
    syscall
    addi $s0, $v0, 0 # a in $s0
    
    #input b
    li $v0, 4
    la $a0, promptB
    syscall
    li $v0, 5
    syscall
    addi $s1, $v0, 0 # b in $s1
    
    # input c
    li $v0, 4
    la $a0, promptC
    syscall
    li $v0, 5
    syscall
    addi $s2, $v0, 0 # c in $s2
    
    # input d
    li $v0, 4
    la $a0, promptD
    syscall
    li $v0, 5
    syscall
    addi $s3, $v0, 0 # d in $s3
    
    # Calculate F
    add $t0, $s0, $s1 # $t0 = a + b
    sub $t1, $s2, $s3 # $t1 = c - d
    mul $t0, $t0, $t1 # $t0 = $t0 * $t1
    mul $t1, $s0, $s0 # $t1 = a * a
    
    li $v0, 4
    la $a0, promptF
    syscall
    li $v0, 2
    mtc1 $t0, $f0
    cvt.s.w $f0, $f0
    mtc1 $t1, $f1
    cvt.s.w $f1, $f1
    div.s $f12, $f0, $f1 # F
    syscall
    
    # Calculate G
    addi $t0, $s0, 1 # t0 = a + 1
    addi $t1, $s1, 2 # t1 = b + 2
    addi $t2, $s2, -3 # t2 = c - 3
    mul $t0, $t0, $t1 # t0 = (a + 1) * (b + 2)
    mul $t1, $t0, $t2 # t1 = (a + 1) * (b + 2) * (c - 3)
    sub $t2, $s2, $s0 # t2 = c - a
    
    li $v0, 4
    la $a0, promptG
    syscall
    li $v0, 2
    mtc1 $t0, $f0
    cvt.s.w $f0, $f0
    mtc1 $t2, $f1
    cvt.s.w $f1, $f1
    div.s $f12, $f0, $f1 # F
    syscall
    
