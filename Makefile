LIBS = 
LIB_DIR =  
FLAGS = -g -Wall -D_GNU_SOURCE

.PHONY: clean all

all: fast slow multiplicacion_matrices multiplicacion_matrices_tr

fast: fast.c arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

slow: slow.c arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

multiplicacion_matrices: multiplicacion_matrices.c arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

multiplicacion_matrices_tr: multiplicacion_matrices_tr.c arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

clean:
	rm -f *.o *~ fast slow multiplicacion_matrices multiplicacion_matrices_tr
