#!/bin/bash

# inicializar variables
p=$((16%8+1))
n_pasos=10
n_repeticiones=10
tam_inicio=$((512+p))
tam_paso=64
tam_final=$((1024+512+p))
num_threads=3
f_dat_tiempos=graficas/tiempos

mkdir graficas

rm -f $f_dat_tiempos.dat $f_dat_tiempos.png
touch $f_dat_tiempos.dat

echo "Running tests..."
for ((r = 1; r <= n_repeticiones; r += 1)); do
	echo "Repeticion $r:"
	for ((tam = tam_inicio; tam <= tam_final; tam += tam_paso)); do
		echo " ---> Tam: $tam / $tam_final..."
		
		tiempo_serie=$(./multiplicacion_matrices_serie $tam | grep 'time' | awk '{print $3}')
		tiempo_par=$(./multiplicacion_matrices_par_3 $tam $num_threads | grep 'time' | awk '{print $3}')

		echo "$tam $tiempo_serie $tiempo_par" >> $f_dat_tiempos.dat
	done
done

python3 calculo_medias.py $f_dat_tiempos.dat
echo "Generating plot..."

gnuplot << END_GNUPLOT
set title "Matrix multiplication runtime"
set ylabel "Runtime"
set xlabel "Matrix size"
set key right bottom
set grid
set term png
set output "$f_dat_tiempos.png"
plot "$f_dat_tiempos.dat" using 1:2 with lines lw 2 title "Serie", \
    "$f_dat_tiempos.dat" using 1:3 with lines lw 2 title "Parallel"
replot
quit
END_GNUPLOT