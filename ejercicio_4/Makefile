LIBS = 
LIB_DIR =  
FLAGS = -g -lgomp -Wall -D_GNU_SOURCE -fopenmp

.PHONY: clean all

all: omp1  clear

omp1: omp1.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

pi_serie.c:
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)


clean:
	rm -f *.o *~ omp1 omp2 pescalar_serie pescalar_par1 pescalar_par2
	
clear:
	rm -f *.o *~
