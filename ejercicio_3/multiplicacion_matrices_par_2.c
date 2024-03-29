//P3 arq 2019-2020
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#include "arqo4.h"

void compute(float **matrix1, float **matrix2, float **matrix3, int n, int num_threads);

int main( int argc, char *argv[]) {
	int n, num_threads;
	float **matrix1 = NULL, **matrix2 = NULL, **matrix3 = NULL;
	struct timeval fin, ini;

	printf("Word size: %ld bits\n", 8*sizeof(float));

	if(argc != 3) {
		printf("Error: ./%s <matrix size> <num_threads>\n", argv[0]);
		return -1;
	}

	n = atoi(argv[1]);
	num_threads = atoi(argv[2]);
	matrix1 = generateMatrix(n);
	matrix2 = generateMatrix(n);
	matrix3 = generateEmptyMatrix(n);
	if (matrix1 == NULL || matrix2 == NULL || matrix3 == NULL) {
        if (matrix1 != NULL) freeMatrix(matrix1);
        if (matrix2 != NULL) freeMatrix(matrix2);
        if (matrix3 != NULL) freeMatrix(matrix3);
		return -1;
	}

	gettimeofday(&ini,NULL);

	/* Main computation */
	compute(matrix1 ,matrix2, matrix3, n, num_threads);
	/* End of computation */

	gettimeofday(&fin,NULL);
	printf("Execution time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);
	
	freeMatrix(matrix1);
	freeMatrix(matrix2);
	freeMatrix(matrix3);
	return 0;
}

void compute(float **matrix1, float **matrix2, float **matrix3, int n, int num_threads) {
	int i, j, k;

    for (i = 0; i < n; i++) {
		#pragma omp parallel for private(k) num_threads(num_threads)
        for (j = 0; j < n; j++) {
			for (k = 0; k < n; k++) {
                matrix3[i][j] += matrix1[i][k]*matrix2[k][j];
            } 
        }
    }
}