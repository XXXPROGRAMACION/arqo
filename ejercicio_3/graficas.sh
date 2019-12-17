#!/bin/bash

# inicializar variables
p=$((16%8+1))
n_pasos=10
tam_inicio=$((512+p))
tam_paso=64
tam_final=$((1024+512+p))
f_dat_tiempos=graficas/tiempos

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