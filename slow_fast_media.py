import sys

if len(sys.argv) != 2:
    print('Número incorrecto de argumentos.')
    exit()

file = open(sys.argv[1], 'r')

averages = {}

for line in file.readlines():
    words = line.split()
    n = int(words[0].replace(",", ""))
    values = []
    for word in words[1:]:
        values.append(float(word.replace(",", "")))
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
file = open(sys.argv[1], 'w')

for n, averages in averages.items():
    file.write(str(n))
    for average in averages['values']:
        file.write('\t' + str(average))
    file.write('\n')
        
file.close()
