# Ejemplo script, para P3 arq 2019-2020

#!/bin/bash

# inicializar variables
p=16%7+4
n_pasos=16 #Antes 16
n_repeticiones=2 #Antes 10
n_inicio=$((32+16*p))
tam_paso=16
n_final=$((n_inicio+(n_pasos-1)*tam_paso))
n_tams=4
tam_inicio=1024
f_dat=mult_
f_time_png=mult_time_
f_cache_png=mult_cache_


tam_cache=$tam_inicio
for ((t = 1; t <= n_tams; t += 1)); do
	# borrar el fichero DAT y el fichero PNG
	rm -f $f_dat$tam_cache.dat $f_png_lectura$tam_cache.png $f_png_escritura$tam_cache.png

	# generar el fichero DAT vacío
	touch $f_dat$tam_cache.dat

	tam_cache=$((tam_cache*2))
done

echo "Running multiplicacion_matrices..."
for ((r = 1; r <= n_repeticiones; r += 1)); do
	echo "Repeticion $r:"

	tam_cache=$tam_inicio
	for ((t = 1; t <= n_tams; t += 1)); do
		echo " -> Tamaño: $tam_cache..."

		for ((p = 0; p < n_pasos; p += 1)); do
			n=$((n_inicio+tam_paso*p))

			echo " ---> n: $n / $n_final..."

			multTime=$(valgrind -q --tool=cachegrind --cachegrind-out-file=cachegrind_mult.out --I1=$tam_cache,1,64 --D1=$tam_cache,1,64 --LL=8388608,1,64 ./multiplicacion_matrices $n | grep 'time' | awk '{print $3}')
			multData=$(cg_annotate cachegrind_mult.out | grep 'PROGRAM TOTALS')
			multRE=$(echo $multData | awk '{print $4}')
			multWE=$(echo $multData | awk '{print $7}')

			multTrTime=$(valgrind -q --tool=cachegrind --cachegrind-out-file=cachegrind_mult.out --I1=$tam_cache,1,64 --D1=$tam_cache,1,64 --LL=8388608,1,64 ./multiplicacion_matrices_tr $n | grep 'time' | awk '{print $3}')
			multTrData=$(cg_annotate cachegrind_mult.out | grep 'PROGRAM TOTALS')
			multTrRE=$(echo $multTrData | awk '{print $4}')
			multTrWE=$(echo $multTrData | awk '{print $7}')
			
			echo "$n	$multTime	$multRE	$multWE	$multTrTime	$multTrRE	$multTrWE" >> $f_dat$tam_cache.dat
		done

		tam_cache=$((tam_cache*2))
	done
done

tam_cache=$tam_inicio
for ((t = 1; t <= n_tams; t += 1)); do
	python3 calculo_medias.py $f_dat$tam_cache.dat

	echo "Generating plot for size $tam_cache..."
	# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
	# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"

gnuplot << END_GNUPLOT
set title "Matrix Multiplication Execution Time (cache $tam_cache bytes)"
set ylabel "Execution time (s)"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$f_time_png$tam_cache.png"
plot "$f_dat$tam_cache.dat" using 1:2 with lines lw 2 title "normal", \
     "$f_dat$tam_cache.dat" using 1:5 with lines lw 2 title "transposed"
replot
quit
END_GNUPLOT

gnuplot << END_GNUPLOT
set title "Matrix Multiplications Cache Fails (cache $tam_cache bytes)"
set ylabel "Fails"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$f_cache_png$tam_cache.png"
plot "$f_dat$tam_cache.dat" using 1:3 with lines lw 2 title "Normal Read Fails", \
    "$f_dat$tam_cache.dat" using 1:4 with lines lw 2 title "Normal Write Fails", \
    "$f_dat$tam_cache.dat" using 1:6 with lines lw 2 title "Transposed Read Fails", \
    "$f_dat$tam_cache.dat" using 1:7 with lines lw 2 title "Transposed Write Fails"
replot
quit
END_GNUPLOT

	tam_cache=$((tam_cache*2))
done