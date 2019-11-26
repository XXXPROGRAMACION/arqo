# Ejemplo script, para P3 arq 2019-2020

#!/bin/bash

# inicializar variables
p=16%7+4
n_pasos=16
n_repeticiones=10
n_inicio=$((10000+1024*p))
tam_paso=64
n_final=$((n_inicio+(n_pasos-1)*tam_paso))
f_dat=slow_fast_time
f_png=slow_fast_time

# borrar el fichero DAT y el fichero PNG
rm -f $f_dat.dat f_png.png

# generar el fichero DAT vacío
touch $f_dat.dat

echo "Running slow and fast..."
# bucle para n desde P hasta Q 
# for n in $(seq $n_inicio $tam_paso $n_final);
for ((r = 1; r <= n_repeticiones; r += 1)); do
	echo "Repeticion $r:"
	for ((n = n_inicio ; n <= n_final ; n += tam_paso)); do
		echo " -> n: $n / $n_final..."
		
		slowTime=$(./slow $n | grep 'time' | awk '{print $3}')
		fastTime=$(./fast $n | grep 'time' | awk '{print $3}')

		echo "$n	$slowTime	$fastTime" >> $f_dat.dat
	done
done


python3 slow_fast_media.py $f_dat.dat

echo "Generating plot..."
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
gnuplot << END_GNUPLOT
set title "Slow-Fast Execution Time"
set ylabel "Execution time (s)"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$f_png.png"
plot "$f_dat.dat" using 1:2 with lines lw 2 title "slow", \
     "$f_dat.dat" using 1:3 with lines lw 2 title "fast"
replot
quit
END_GNUPLOT