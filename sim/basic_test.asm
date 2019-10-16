.data
num0: .word 1 # posic 0
num1: .word 2 # posic 4
num2: .word 3 # posic 8 
num3: .word 0 # posic 12 
num4: .word 0 # posic 16 
num5: .word 0 # posic 20
num6: .word 0 # posic 24
num7: .word 0 # posic 28

.text
main: 
  lw $t1, 0($zero) # En r1 un 1
  lw $t2, 4($zero) # En r2 un 2
  lw $t3, 8($zero) # En r3 un 3
  nop
  nop
  nop
  add $t4, $t1, $t2 # En r4 un 3
  sub $t4, $t3, $t1 # En r4 un 2
  and $t4, $t1, $t3 # En r4 un 1
  or $t4, $t1, $t2 # En r4 un 3
  xor $t4, $t1, $t3 # En r4 un 2
  addi $t4, $t3, -2 # En r4 un 1
  lui $t5, 0x321 # En r5 un 0x321*2^16
  nop
  nop
  nop
  sw $t4, 12($zero) # En num3 un 0x321*2^16
  nop
  nop
  nop
  j salto
  nop
  nop
  nop
  addi $t5, $0, 0xFABADA # En r5 un 0xFABADA
  nop
  nop
  nop
  salto:
  beq $t4, $t1, salto_beq
  nop
  nop
  nop
  addi $t6, $0, 0xFABADA # En r6 un 0xFABADA
  nop
  nop
  nop
  salto_beq:
  beq $t4, $t2, fin
  nop
  nop
  nop
  addi $t7, $0, 0xCAFE # En r7 un 0xCAFE
  nop
  nop
  nop
  fin:
  j fin
  nop
  nop
  nop
  nop
  nop
