# FICHERO PARA PROBAR LA GENERACIÓN DE GRÁFICAS PARA EL EJ2

# inicializar variables
p=16%7+4
n_pasos=2
n_repeticiones=1
n_inicio=$((2000+512*p))
tam_paso=64
n_final=$((n_inicio+(n_pasos-1)*tam_paso))
n_tams=4
tam_inicio=1024
f_dat=cache_
f_png_lectura=cache_lectura_
f_png_escritura=cache_escritura_


tam_cache=$tam_inicio
for ((t = 1; t <= n_tams; t += 1)); do
	python3 slow_fast_media.py $f_dat$tam_cache.dat

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
