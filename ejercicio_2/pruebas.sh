#!/bin/bash

# inicializar variables
n_pasos=10
n_repeticiones=3
tam_inicio=$((2000+512*p))
tam_paso=64
tam_final=$((tam_inicio+(n_pasos-1)*tam_paso))
n_nucleos_inicio=1
n_nucleos_final=4
f_dat_tiempos=tiempos_nucleos_
f_dat_aceleracion=aceleracion_tam_

for ((n_nucleos = n_nucleos_inicio; n_nucleos <= n_nucleos_final; n_nucleos += 1)); do
	rm -f $f_dat_tiempos$n_nucleos.dat $f_dat_tiempos$n_nucleos.png
	touch $f_dat_tiempos$n_nucleos.dat
done

for ((tam = tam_inicio; tam <= tam_final; tam += tam_paso)); do
	rm -f $f_dat_aceleracion$tam.dat $f_dat_aceleracion$tam.png
	touch $f_dat_aceleracion$tam.dat
done

echo "Running tests..."
for ((r = 1; r <= n_repeticiones; r += 1)); do
	echo "Repeticion $r:"

    for ((n_nucleos = n_nucleos_inicio; n_nucleos <= n_nucleos_final; n_nucleos += 1)); do
		echo " -> Nucleos: $n_nucleos / $n_nucleos_final..."

        for ((tam = tam_inicio; tam <= tam_final; tam += tam_paso)); do
			echo " ---> Tam: $tam / $tam_final..."
			
			tiempo_serie=$(./pescalar_serie $tam | grep 'Tiempo' | awk '{print $2}')
            tiempo_par=$(./pescalar_par $tam $n_nucleos | grep 'Tiempo' | awk '{print $2}')

			echo "$tam $tiempo_serie $tiempo_par" >> $f_dat_tiempos$n_nucleos.dat
            echo "$n_nucleos $tiempo_serie $tiempo_par" >> $f_dat_aceleracion$tam.dat
		done
	done
done

for ((n_nucleos = n_nucleos_inicio; n_nucleos <= n_nucleos_final; n_nucleos += 1)); do
	python3 calculo_medias.py $f_dat_tiempos$n_nucleos.dat
    echo "Generating plot for $n_nucleos cores..."

gnuplot << END_GNUPLOT
set title "Serie-Parallel runtimes ($n_nucleos cores)"
set ylabel "Runtime"
set xlabel "Vector size"
set key right bottom
set grid
set term png
set output "$f_dat_tiempos$n_nucleos.png"
plot "$f_dat_tiempos$n_nucleos.dat" using 1:2 with lines lw 2 title "Serie", \
    "$f_dat_tiempos$n_nucleos.dat" using 1:3 with lines lw 2 title "Parallel"
replot
quit
END_GNUPLOT

done

for ((tam = tam_inicio; tam <= tam_final; tam += tam_paso)); do
	python3 calculo_medias.py $f_dat_aceleracion$tam.dat
	echo "Generating plot for size $tam..."

gnuplot << END_GNUPLOT
set title "Serie-Parallel runtimes (size $tam)"
set ylabel "Runtime"
set xlabel "Number of cores"
set key right bottom
set grid
set term png
set output "$f_dat_aceleracion$tam.png"
plot "$f_dat_aceleracion$tam.dat" using 1:2 with lines lw 2 title "Serie", \
    "$f_dat_aceleracion$tam.dat" using 1:3 with lines lw 2 title "Parallel"
replot
quit
END_GNUPLOT

done
