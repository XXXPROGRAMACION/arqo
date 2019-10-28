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
  lw $1, 0($zero) # En r1 un 1
  lw $2, 4($zero) # En r2 un 2
  lw $3, 8($zero) # En r3 un 3
  nop
  nop
  nop
  add $4, $1, $2 # En r4 un 3
  beq $3, $4, salto_1
  nop
  nop
  add $10, $1, $zero # En r10 un 1
  nop
  nop
  nop
  j fin
  nop
  nop
  nop
  salto_1:
  add $4, $2, $2 # En r4 un 4
  nop
  nop
  nop
  lw $5, 8($zero) # En r5 un 3
  beq $3, $5, salto_2
  nop
  nop
  nop
  add $11, $1, $zero # En r11 un 1
  nop
  nop
  nop
  salto_2:
  add $5, $2, $3
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
