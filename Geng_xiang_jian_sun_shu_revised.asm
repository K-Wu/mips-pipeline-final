j 		Start
j 		ill_handler
j 		IRQ # -1
IRQ:
lui 	$t9, 0x4000 #-2
lw 		$s1, 8($t9)#handling timer 
andi	$t8, $s1, 4
andi	$s1, $s1, 0xfffb #不应该关掉使能
sw		$s1, 8($t9)
bne		$t8, $zero, Timer
lw 		$s1, 32($t9)#handling uart
andi	$t7, $s1, 8  
#andi	$s1, $s1, 0xfff0 #不应该关掉使能
#sw		$s1, 32($t9)
bne		$t7, $zero, Read
andi    $t6, $s1, 4
bne     $t6, $zero, Write
j       ill_handler #不属于以上中断的任何一个，遇到了bug
Write: #写中断的意思是写好，准备跳转到Wait1
addi	$v0, $zero, 0 
j       Return
Return:
lw 		$s1, 8($t9) # -3
addi	$t8, $zero, 2
or		$s1, $s1, $t8
sw		$s1, 8($t9)
#lw 		$s1, 32($t9)
#or		$s1, $s1, $t8
addi	$t8, $zero, 3
sw		$t8, 32($t9) #uart以防前面禁止了中断没被发现
addi	$k0, $k0, -4
jr 		$k0
Timer:
lw		$s2, 20($t9) # -4
andi	$t7, $s2, 0x0f00
addi	$t2, $zero, 0x0700
addi	$t1, $zero, 0x0b00
beq		$t7, $t2, Second
addi	$t2, $zero, 0x0b00
addi	$t1, $zero, 0x0d00
beq		$t7, $t2, Third
addi	$t2, $zero, 0x0d00
addi	$t1, $zero, 0x0e00
beq		$t7, $t2, Fourth
addi	$t1, $zero, 0x0700
andi	$t6, $a2, 0x00f0
srl 	$t6, $t6, 4
j 		Decode
Second:
andi	$t6, $a2, 0x000f # -5
j 		Decode
Third:
andi	$t6, $a3, 0x00f0 # -6
srl 	$t6, $t6, 4
j 		Decode
Fourth:
andi	$t6, $a3, 0x000f # -7
j 		Decode
Decode:
addi	$t5, $zero, 0 # -8
addi	$t4, $zero, 0xc0
beq		$t5, $t6, Digi
addi	$t5, $zero, 1
addi	$t4, $zero, 0xf9
beq		$t5, $t6, Digi
addi	$t5, $zero, 2
addi	$t4, $zero, 0xa4
beq		$t5, $t6, Digi
addi	$t5, $zero, 3
addi	$t4, $zero, 0xb0
beq		$t5, $t6, Digi
addi	$t5, $zero, 4
addi	$t4, $zero, 0x99
beq		$t5, $t6, Digi
addi	$t5, $zero, 5
addi	$t4, $zero, 0x92
beq		$t5, $t6, Digi
addi	$t5, $zero, 6
addi	$t4, $zero, 0x82
beq		$t5, $t6, Digi
addi	$t5, $zero, 7
addi	$t4, $zero, 0xf8
beq		$t5, $t6, Digi
addi	$t5, $zero, 8
addi	$t4, $zero, 0x80
beq		$t5, $t6, Digi
addi	$t5, $zero, 9
addi	$t4, $zero, 0x90
beq		$t5, $t6, Digi
addi	$t5, $zero, 10
addi	$t4, $zero, 0x88
beq		$t5, $t6, Digi
addi	$t5, $zero, 11
addi	$t4, $zero, 0x83
beq		$t5, $t6, Digi
addi	$t5, $zero, 12
addi	$t4, $zero, 0xc6
beq		$t5, $t6, Digi
addi	$t5, $zero, 13
addi	$t4, $zero, 0xa1
beq		$t5, $t6, Digi
addi	$t5, $zero, 14
addi	$t4, $zero, 0x86
beq		$t5, $t6, Digi
addi	$t4, $zero, 0x8e
Digi:
add 	$s2, $t4, $t1 # -9
sw		$s2, 20($t9)
j 		Return
Read:
beq		$a0, $zero, Firstpara # -10
beq		$a1, $zero, Secondpara
j 		Return
Secondpara:
lw		$a1, 28($t9) # -11
j 		Return
Firstpara:
lw		$a0, 28($t9) # -12
j 		Return
ill_handler:
j		ill_handler # -13
Next:
sll		$ra, $ra, 1 # -14
srl		$ra, $ra, 1
jr		$ra
Start: 
jal 	Next # -15
lui 	$t9, 0x4000#设置基址
sw 		$zero, 8($t9)#关闭定时器
lui		$t8, 0xffff 
addi 	$t8, $zero, 0xd8ef #设置TH
sw		$t8, 0($t9)
lui		$t8, 0xffff
addi 	$t8, $zero, 0xffff
sw		$t8, 4($t9) #FFFFFFFF设置TL
sw		$t8, 20($t9)#设置数码管
addi 	$t8, $zero, 3
sw		$t8, 8($t9) #打开计时器
addi    $t8, $zero, 0x000e #禁止写中断使能
sw      $t8, 32($t9)
Wait1:  #等待两个输入
beq		$a0, $zero, Wait1 # -16
beq		$a1, $zero, Wait1
add 	$a2, $a0, $zero
add 	$a3, $a1, $zero
addi    $t8, $zero, 0x000c #禁止读写中断使能
sw      $t8, 32($t9)
Check:
slt		$t0, $a2, $a3 # -17
bne		$t0, $zero, Less
More:
sub 	$a2, $a2, $a3 # -18
bne 	$a2, $zero, Check
add 	$a2, $zero, $a3
j		Result
Less:
sub 	$a3, $a3, $a2 # -19
bne 	$a3, $zero, Check
Result:
add 	$v0, $a2, $zero # -20
sw 		$v0, 12($t9) #led
addi	$a0, $zero, 0
addi	$a0, $zero, 0
Wait2Prepare: 
lw      $t8, 32($t9)
andi    $t8, $t8, 0x0010 #判断是否发送器就绪
bne     $t8, $zero, Wait2Prepare#如果发送器未就绪，死循环
sw		$v0, 24($t9) #发送数据
addi    $t8, $zero, 0x000d
sw      $t8, 32($t9)#使能写中断，读中断依然禁止
Wait2: #等待Uart发送完数据，就绪产生写中断
bne     $v0, $zero, Wait2

addi    $t8, $zero, 0x000e
sw      $t8, 32($t9)#禁止写中断
j 		Wait1