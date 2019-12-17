LIBS = 
LIB_DIR =  
FLAGS = -g -lgomp -Wall -D_GNU_SOURCE -fopenmp
TARGETS = pi_serie pi_par1 pi_par2 pi_par3 pi_par4 pi_par5 pi_par6 pi_par7 omp1 omp2 pescalar_par1 pescalar_par2 pescalar_serie

.PHONY: clean all

all: clean $(TARGETS)

%: %.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

clean:
	rm -f *.o *~ $(TARGETS)
