# Ejemplo script, para P3 arq 2019-2020

#!/bin/bash

# inicializar variables
p=16%7+4
n_pasos=16 #Antes 16
n_repeticiones=1 #Antes 10
n_inicio=$((16+16*p))
tam_paso=64
n_final=$((n_inicio+(n_pasos-1)*tam_paso))
n_tams=4
tam_inicio=1024
f_dat=cache_
f_png_lectura=cache_lectura_
f_png_escritura=cache_escritura_


tam_cache=$tam_inicio
for ((t = 1; t <= n_tams; t += 1)); do
	# borrar el fichero DAT y el fichero PNG
	rm -f $f_dat$tam_cache.dat $f_png_lectura$tam_cache.png $f_png_escritura$tam_cache.png

	# generar el fichero DAT vacío
	touch $f_dat$tam_cache.dat

	tam_cache=$((tam_cache*2))
done

echo "Running slow and fast..."
for ((r = 1; r <= n_repeticiones; r += 1)); do
	echo "Repeticion $r:"

	tam_cache=$tam_inicio
	for ((t = 1; t <= n_tams; t += 1)); do
		echo " -> Tamaño: $tam_cache..."

		for ((p = 0; p < n_pasos; p += 1)); do
			n=$((n_inicio+tam_paso*p))

			echo " ---> n: $n / $n_final..."
			
			valgrind -q --tool=cachegrind --cachegrind-out-file=cachegrind.out --I1=$tam_cache,1,64 --D1=$tam_cache,1,64 --LL=8388608,1,64 ./slow $n
			slowData=$(cg_annotate cachegrind.out | grep 'PROGRAM TOTALS')
			slowRE=$(echo $slowData | awk '{print $4}')
			slowWE=$(echo $slowData | awk '{print $7}')
			
			valgrind -q --tool=cachegrind --cachegrind-out-file=cachegrind.out --I1=$tam_cache,1,64 --D1=$tam_cache,1,64 --LL=8388608,1,64 ./fast $n
			fastData=$(cg_annotate cachegrind.out | grep 'PROGRAM TOTALS')
			fastRE=$(echo $fastData | awk '{print $4}')
			fastWE=$(echo $fastData | awk '{print $7}')

			echo "$n	$slowRE	$slowWE	$fastRE	$fastWE" >> $f_dat$tam_cache.dat
		done

		tam_cache=$((tam_cache*2))
	done
done

tam_cache=$tam_inicio
for ((t = 1; t <= n_tams; t += 1)); do

	echo "Generating plot for size $tam_cache..."
	# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
	# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
	

gnuplot << END_GNUPLOT
set title "Slow-Fast Cache Read Fails"
set ylabel "Read Fails"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$f_png_lectura$tam_cache.png"
plot "$f_dat$tam_cache.dat" using 1:2 with lines lw 2 title "slow", \
    "$f_dat$tam_cache.dat" using 1:4 with lines lw 2 title "fast"
replot
quit
END_GNUPLOT

gnuplot << END_GNUPLOT
set title "Slow-Fast Cache Write Fails"
set ylabel "Write Fails"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$f_png_escritura$tam_cache.png"
plot "$f_dat$tam_cache.dat" using 1:3 with lines lw 2 title "slow", \
    "$f_dat$tam_cache.dat" using 1:5 with lines lw 2 title "fast"
replot
quit
END_GNUPLOT


	tam_cache=$((tam_cache*2))
done