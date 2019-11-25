# Ejemplo script, para P3 arq 2019-2020

#!/bin/bash

# inicializar variables
p=16%7+4
n_pasos=10 #Antes 16
n_repeticiones=2 #Antes 10
n_inicio=10 #Antes $((256+256*p))
tam_paso=16
n_final=$((n_inicio+(n_pasos-1)*tam_paso))
f_dat=mult
f_time_png=mult_time
f_cache_png=mult_cache

# borrar el fichero DAT y el fichero PNG
rm -f $f_dat.dat $f_time_png.png $f_cache_png.png

# generar el fichero DAT vacío
touch $f_dat.dat

echo "Running multiplicacion_matrices..."
# bucle para n desde P hasta Q 
# for n in $(seq $n_inicio $tam_paso $n_final);
for ((r = 1; r <= n_repeticiones; r += 1)); do
	echo "Repeticion $r:"
	for ((n = n_inicio ; n <= n_final ; n += tam_paso)); do
		echo " -> n: $n / $n_final..."

		multTime=$(valgrind -q --tool=cachegrind --cachegrind-out-file=cachegrind_mult.out --I1=8192,1,64 --D1=8192,1,64 --LL=8388608,1,64 ./multiplicacion_matrices $n | grep 'time' | awk '{print $3}')
		multData=$(cg_annotate cachegrind_mult.out | grep 'PROGRAM TOTALS')
		multRE=$(echo $multData | awk '{print $4}')
		multWE=$(echo $multData | awk '{print $7}')

		multTrTime=$(valgrind -q --tool=cachegrind --cachegrind-out-file=cachegrind_mult.out --I1=8192,1,64 --D1=8192,1,64 --LL=8388608,1,64 ./multiplicacion_matrices_tr $n | grep 'time' | awk '{print $3}')
		multTrData=$(cg_annotate cachegrind_mult.out | grep 'PROGRAM TOTALS')
		multTrRE=$(echo $multTrData | awk '{print $4}')
		multTrWE=$(echo $multTrData | awk '{print $7}')
		
		echo "$n	$multTime	$multRE	$multWE	$multTrTime	$multTrRE	$multTrWE" >> $f_dat.dat
	done
done

python3 slow_fast_media.py $f_dat.dat

echo "Generating plots..."
gnuplot << END_GNUPLOT
set title "Matrix Multiplication Execution Time"
set ylabel "Execution time (s)"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$f_time_png.png"
plot "$f_dat.dat" using 1:2 with lines lw 2 title "normal", \
     "$f_dat.dat" using 1:5 with lines lw 2 title "transposed"
replot
quit
END_GNUPLOT

gnuplot << END_GNUPLOT
set title "Matrix Multiplications Cache Fails"
set ylabel "Fails"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$f_cache_png.png"
plot "$f_dat.dat" using 1:3 with lines lw 2 title "Normal Read Fails", \
    "$f_dat.dat" using 1:4 with lines lw 2 title "Normal Write Fails", \
    "$f_dat.dat" using 1:6 with lines lw 2 title "Transposed Read Fails", \
    "$f_dat.dat" using 1:7 with lines lw 2 title "Transposed Write Fails"
replot
quit
END_GNUPLOT
