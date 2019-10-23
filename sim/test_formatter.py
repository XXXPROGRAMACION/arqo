import sys

if len(sys.argv) != 2:
    print('Número de argumentos inválido.')
    exit()

lines = []

with open(sys.argv[1], 'r') as fp:
    val = 0
    line = fp.readline()
    while line:
        val_str = hex(val)[2:]
        while len(val_str) < 8:
            val_str = '0' + val_str
        print(val_str + ' ' + line[:-1])
        lines.append(val_str + '\t' + line)
        line = fp.readline()
        val += 4
    
with open(sys.argv[1], 'w') as fp:
    for line in lines:
        fp.write(line)