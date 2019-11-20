import sys

if len(sys.argv) != 2:
    print('Número incorrecto de argumentos.')
    exit()

file = open(sys.argv[0], 'r')

averages = {}

for line in file.readlines():
    words = line.split()
    n = int(words[0])
    values = []
    for word in words[1:]:
        values.append(float(word))
    if averages.get(n) is None:
        averages[n] = {
            'values': values,
            'samples': 1
        }
    else:
        values_averages = averages[n]['values']
        samples = averages[n]['samples']
        for i in range(0, len(values_averages)):
            values_averages[i] *= samples
            values_averages[i] += values[i]
            values_averages[i] /= samples+1
        averages[n]['samples'] += 1

file.close()
file = open(sys.argv[0], 'w')

for n, slow_fast_average in averages.items():
    file.write(str(n) + '\t' + str(slow_fast_average['slow_average']) + '\t' + str(slow_fast_average['fast_average']) + '\n')
        
file.close()
