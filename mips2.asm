.data
promptInput: .asciiz "Enter 20 element: "
promtResult: .asciiz "The reverse: "
space: .asciiz ", "

.text
main:
# printing out promptInput
li $v0, 4
la $a0, promptInput
syscall

# input array into a stack
li $t0, 20
loopi:
li $v0, 5
addi $t0, $t0, -1
syscall
addi $sp, $sp, -4
sw $v0, 0($sp) # save to stack
bne $t0, $zero, loopi

# print reverse
li $t0, 19
loopo:
addi $t0, $t0, -1
li $v0, 1
lw $a0, 0($sp)
syscall
li $v0, 4
la $a0, space
syscall
addi $sp, $sp, 4
bne $t0, $zero, loopo

# print last
li $v0, 1
lw $a0, 0($sp)
syscall





