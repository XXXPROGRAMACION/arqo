# FICHERO PARA PROBAR LA GENERACIÓN DE GRÁFICAS PARA EL EJ3
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
