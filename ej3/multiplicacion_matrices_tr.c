//P3 arq 2019-2020
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#include "arqo3.h"

void compute(tipo **matrix1, tipo **matrix2, tipo **matrix3, int n);

void transpose(tipo **matrix_og, tipo **matrix_dst, int n);

int main( int argc, char *argv[]) {
	int n;
	tipo **matrix1 = NULL, **matrix2 = NULL, **matrix3 = NULL, **matrix4 = NULL;
	struct timeval fin, ini;

	printf("Word size: %ld bits\n", 8*sizeof(tipo));

	if(argc != 2) {
		printf("Error: ./%s <matrix size>\n", argv[0]);
		return -1;
	}

	n = atoi(argv[1]);
	matrix1 = generateMatrix(n);
	matrix2 = generateMatrix(n);
	matrix3 = generateEmptyMatrix(n);
	matrix4 = generateEmptyMatrix(n);
	if (matrix1 == NULL || matrix2 == NULL || matrix3 == NULL || matrix4 == NULL) {
        if (matrix1 != NULL) freeMatrix(matrix1);
        if (matrix2 != NULL) freeMatrix(matrix2);
        if (matrix3 != NULL) freeMatrix(matrix3);
        if (matrix4 != NULL) freeMatrix(matrix4);
		return -1;
	}

	gettimeofday(&ini,NULL);

	/* Main computation */
	transpose(matrix2, matrix4, n);
	compute(matrix1 ,matrix4, matrix3, n);
	/* End of computation */

	gettimeofday(&fin,NULL);
	printf("Execution time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);
	
	freeMatrix(matrix1);
	freeMatrix(matrix2);
	freeMatrix(matrix3);
	freeMatrix(matrix4);
	return 0;
}

void compute(tipo **matrix1, tipo **matrix2, tipo **matrix3, int n) {
	int i, j, k;

    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            for (k = 0; k < n; k++) {
                matrix3[i][j] += matrix1[i][k]*matrix2[j][k];
            }
        }
    }
}

void transpose(tipo **matrix_og, tipo **matrix_dst, int n) {
	int i, j;

	for (i = 0; i < n; i++) {
		for (j = 0; j < n; j++) {
			matrix_dst[i][j] = matrix_og[j][i];
		}
	}
}