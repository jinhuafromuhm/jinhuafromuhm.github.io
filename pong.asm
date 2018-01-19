# Important: do not put any other data before the frameBuffer
# Also: the Bitmap Display tool must be connected to MARS and set to
#   unit width in pixels: 8
#   unit height in pixels: 8
#   display width in pixels: 256
#   display height in pixels: 256
#   base address for display: 0x10010000 (static data)
.data
frameBuffer:

.text
# Example of drawing a Column; x-coordinate is set by $a0, 
# the pattern is set by the 32 bits in $a1
	li $a0 27
	addi $s1,$a1,0
	addi $s2,$s2,0#upcounter
	addi $s4,$s4,0#0 when move left, 1 move right
	addi $s5,$s5,0x6000000
	addi $s6,$s6,0x9000000
	li $s7  0
	

#
ballback:
	li $s4 0
	beq $a0,0,ball
	beq $s2 3 up
	beq $s6 0x90000000 dir
	beq $s6 0x9 dir2
	skip:
	addi $a0,$a0,0
	addi $a1,$s5,0
	jal SetColumn
	addi $a0,$a0,1
	addi $a1,$s6,0
	jal SetColumn
	addi $a0,$a0,1
	addi $a1,$s6,0
	jal SetColumn
	addi $a0,$a0,1
	addi $a1,$s5,0
	jal SetColumn
	li $a1,0
	jal SetColumn
	addi $a0,$a0,-1
	jal SetColumn
	addi $a0,$a0,-1
	jal SetColumn
	addi $a0,$a0,-1
	jal SetColumn
	addi $a0,$a0,-1
	addi $s2,$s2,1
	jal ballback
ball:	
	li $s4 1
	beq $a0,28,ballback
	beq $s2,3 up
	beq $s6, 0x90000000 dir
	beq $s6 0x9 dir2
	skip2:
	addi $a0,$a0,0
	addi $a1,$s5,0
	jal SetColumn
	addi $a0,$a0,1
	addi $a1,$s6,0
	jal SetColumn
	addi $a0,$a0,1
	addi $a1,$s6,0
	jal SetColumn
	addi $a0,$a0,1
	addi $a1,$s5,0
	jal SetColumn
	li $a1,0
	jal SetColumn
	addi $a0,$a0,-1
	jal SetColumn
	addi $a0,$a0,-1
	jal SetColumn
	addi $a0,$a0,-1
	jal SetColumn
	addi $a0,$a0,1
	addi $s2,$s2,1
	jal ball
up:
li $s2 0
beq $s7 1, down
sll $s5,$s5 1
sll $s6,$s6,1

beqz $s4 ballback
j ball
down:
srl $s5,$s5 1
srl $s6,$s6,1
beqz $s4 ballback
j ball 
dir:li $s7 1
beq $s4 0, skip
jal skip2
dir2:li $s7 0
beq $s4 0, skip
jal skip2
SetColumn:
  # $a0 is x (must be within the display)
  # $a1 is column encoding
	add $t7, $a1, 0
	li $t0, -1
	li $t6,  0
	la $t1, frameBuffer
	li $t2, 0
   SetColumn_forloop:
	add $t3, $t2,$t2
	add $t3, $t3,$t3
	add $t3, $t3,$t3
	add $t3, $t3,$t3
	add $t3, $t3,$t3
	add $t3, $t3,$t3
	add $t3, $t3,$t3
	add $t3, $t3,$t1
	add $t4, $a0, $a0
	add $t4, $t4, $t4
	add $t4, $t4, $t3
	andi $t8, $t7, 2147483648
	bne $t8, $zero, SetColumn_elsecase 
	sw $t6,($t4)
	j SetColumn_skip_else
      SetColumn_elsecase:
	sw $t0,($t4)
      SetColumn_skip_else:
	addu $t7, $t7, $t7
	addi $t2, $t2, 1
	blt $t2, 33, SetColumn_forloop
	jr $ra

