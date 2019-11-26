LIBS = 
LIB_DIR =  
FLAGS = -g -Wall -D_GNU_SOURCE

.PHONY: clean all

all: multiplicacion_matrices multiplicacion_matrices_tr

multiplicacion_matrices: multiplicacion_matrices.c arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

multiplicacion_matrices_tr: multiplicacion_matrices_tr.c arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

clean:
	rm -f *.o *~ multiplicacion_matrices multiplicacion_matrices_tr
