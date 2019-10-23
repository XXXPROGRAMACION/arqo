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
  add $4, $1, $3 # En r4 un 4
  add $5, $4, $1 # En r5 un 5
  add $6, $4, $2 # En r6 un 6
  add $7, $4, $3 # En r7 un 7
  nop
  nop
  nop
  sw $4, 12($zero) # En num3 un 1
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
