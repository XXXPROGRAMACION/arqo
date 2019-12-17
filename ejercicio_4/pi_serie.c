/*********************************************************/
/*C�lculo PI: M�todo de integraci�n - Version secuencial */
/*********************************************************/

#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>

int main( int argc, char *argv[] ) 
{ 
	int i, n;
	double x, h, pi, sum = 0.0, t = 0;
	struct timeval t1,t2;

	if (argc != 2) {
		printf("Número de argumentos inválido.\n");
		return 1;
	}

	n = atoi(argv[1]);

	gettimeofday(&t1,NULL);
	
	h = 1.0/(double) n;
	for (i=1;i<= n; i++)
	{
		x = h*(i-0.5);
		sum += 4.0/(1.0+x*x);
	}
	pi = h * sum;

	gettimeofday(&t2,NULL);

	t = (t2.tv_sec -t1.tv_sec) + (t2.tv_usec - t1.tv_usec)/(double)1000000;
	printf("Resultado pi: %f\nTiempo %lf\n", pi, t);
		
	return 0;
}
