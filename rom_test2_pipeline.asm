labelstart: sll $0 $0 0
sll $0 $0 0
sll $0 $0 0
sll $0 $0 0
sll $0 $0 0
addi $15 $15 1 #测试连续rs修改并写入 结果正确
addi $15 $15 1
sw $15, 0x0000($16)
addi $14 $14 1
lui $9 0x0001
beq $0 $0 labelb1 #测试beq，j是否能够按照顺序正确执行 测试顺序4
labelb1: jal jdst1 #测试j是否能够清理干净 测试顺序3 通过
lw $9 0x0000($16) #load use hazard 但跳过，因此没有bubble 确实如此
addi $9 $9 1
addi $9 $9 1
jdst1: lw $17 0x0000($16) #load use hazard 并测试读出 读出成功
addiu $17 $17 0x00004 #load-use hazard 测试顺序1 值正确
addiu $16 $0 0x000AA
sw $17 0x0003($16) #未检查
jal jadst1 #测
jadst1: sll $4 $17 0x00004 #h00112100
beq $0 $0 labelb2 #测试2 #测试b 是否清理干净
sll $14 $14 1
sll $14 $14 1
j jdst2 #测试j是否清理干净 测试顺序2 通过
sll $15 $15 1
sll $15 $15 1
labelb2: addi $11 $11 1
jdst2: sra $5 $17 0x00003 #h001128C3
or $17 $4 $17 #h02748825
add $17 $4 $17 #$19>$20 $17=0 h02748820
sw $17 0x0003($16) #hAE110003
slt $17 $19 $20 #h0274882A
beq $0 $17 labelb3 #应该跳过下一条 h10110001 
sub $17 $20 $19
labelb3: sub $17 $19 $20
lw $20 0x0003($16)
j labelstart
