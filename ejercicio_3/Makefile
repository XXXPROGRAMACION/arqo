LIBS = 
LIB_DIR =  
FLAGS = -g -lgomp -Wall -D_GNU_SOURCE -fopenmp

.PHONY: clean all

all: multiplicacion_matrices_serie multiplicacion_matrices_par_1 multiplicacion_matrices_par_2 multiplicacion_matrices_par_3 clear

multiplicacion_matrices_serie: multiplicacion_matrices_serie.c arqo4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)
multiplicacion_matrices_par_1: multiplicacion_matrices_par_1.c arqo4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)
multiplicacion_matrices_par_2: multiplicacion_matrices_par_2.c arqo4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)
multiplicacion_matrices_par_3: multiplicacion_matrices_par_3.c arqo4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

clean:
	rm -f *.o *~ multiplicacion_matrices_serie multiplicacion_matrices_par_1 multiplicacion_matrices_par_2 multiplicacion_matrices_par_3
	
clear:
	rm -f *.o *~
