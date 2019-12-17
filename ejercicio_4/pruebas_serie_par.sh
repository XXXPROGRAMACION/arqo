#!/bin/bash

# inicializar variables
p=$((16%8+1))
n_pasos=10
n_repeticiones=10
tam_inicio=$((10000000*p))
tam_paso=10000000
tam_final=$((10000000*(p+10)))
f_dat_tiempos=graficas/tiempos_serie_par

mkdir graficas

rm -f $f_dat_tiempos.dat $f_dat_tiempos.png
touch $f_dat_tiempos.dat

echo "Running tests..."
for ((r = 1; r <= n_repeticiones; r += 1)); do
	echo "Repeticion $r:"
	for ((tam = tam_inicio; tam <= tam_final; tam += tam_paso)); do
		echo " ---> Tam: $tam / $tam_final..."
		
		tiempo_serie=$(./pi_serie $tam | grep 'Tiempo' | awk '{print $2}')
		tiempo_par_1=$(./pi_par1 $tam | grep 'Tiempo' | awk '{print $2}')
		tiempo_par_2=$(./pi_par2 $tam | grep 'Tiempo' | awk '{print $2}')
		tiempo_par_3=$(./pi_par3 $tam | grep 'Tiempo' | awk '{print $2}')
		tiempo_par_4=$(./pi_par4 $tam | grep 'Tiempo' | awk '{print $2}')

		echo "$tam $tiempo_serie $tiempo_par_1 $tiempo_par_2 $tiempo_par_3 $tiempo_par_4" >> $f_dat_tiempos.dat
	done
done

python3 calculo_medias.py $f_dat_tiempos.dat
echo "Generating plot..."

gnuplot << END_GNUPLOT
set title "Pi calculation runtime"
set ylabel "Runtime"
set xlabel "Number of rectangles"
set key right bottom
set grid
set term png
set output "$f_dat_tiempos.png"
plot "$f_dat_tiempos.dat" using 1:2 with lines lw 2 title "Serie", \
    "$f_dat_tiempos.dat" using 1:3 with lines lw 2 title "Parallel (1)", \
    "$f_dat_tiempos.dat" using 1:4 with lines lw 2 title "Parallel (2)", \
    "$f_dat_tiempos.dat" using 1:5 with lines lw 2 title "Parallel (3)", \
    "$f_dat_tiempos.dat" using 1:6 with lines lw 2 title "Parallel (4)"
replot
quit
END_GNUPLOT