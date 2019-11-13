file = open('slow_fast_time.dat', 'r')

slow_fast_averages = {}

for line in file.readlines():
    words = line.split()
    n = float(words[0])
    slow_time = float(words[1])
    fast_time = float(words[2])
    if slow_fast_averages.get(n) is None:
        slow_fast_averages[n] = {
            "slow_average": slow_time,
            "fast_average": fast_time,
            "samples": 1
        }
    else:
        slow_fast_averages[n]['slow_average'] *= slow_fast_averages[n]['samples']
        slow_fast_averages[n]['slow_average'] += slow_time
        slow_fast_averages[n]['slow_average'] /= slow_fast_averages[n]['samples']+1
        slow_fast_averages[n]['fast_average'] *= slow_fast_averages[n]['samples']
        slow_fast_averages[n]['fast_average'] += fast_time
        slow_fast_averages[n]['fast_average'] /= slow_fast_averages[n]['samples']+1
        slow_fast_averages[n]['samples'] += 1

file.close()
file = open('slow_fast_time.dat', 'w')

for n, slow_fast_average in slow_fast_averages.items():
    file.write(str(n) + '\t' + str(slow_fast_average['slow_average']) + '\t' + str(slow_fast_average['fast_average']) + '\n')
        
file.close()
