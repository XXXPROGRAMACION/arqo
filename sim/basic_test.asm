.data 0
num0: .word 1 # posic 0
num1: .word 2 # posic 4
num2: .word 3 # posic 8 
num3: .word 0 # posic 12 
num4: .word 0 # posic 16 
num5: .word 0 # posic 20
num6: .word 0 # posic 24
num7: .word 0 # posic 28

.text 0
main: 
  lw $1, 0($zero) # En r1 un 1
  lw $2, 4($zero) # En r2 un 2
  lw $3, 8($zero) # En r3 un 3
  nop
  nop
  nop
  add $5, $2, $3 # En r5 un 5
  nop
  nop
  nop
  sub $4, $5, $1 # En r4 un 4
  and $4, $1, $3 # En r4 un 1
  or $4, $1, $2 # En r4 un 3
  xor $4, $1, $3 # En r4 un 2
  addi $4, $3, -2 # En r4 n 1
  lui $1, 0x321 # En r4 un 0x321*2^16
  nop
  nop
  nop
  sw 12($zero), $4 # En num3 un 0x321*2^16
  nop
  nop
  nop
  j salto
  nop
  nop
  nop
  nop
  addi $5, 0xFABADA
  nop
  nop
  nop
  nop
  nop
  salto: