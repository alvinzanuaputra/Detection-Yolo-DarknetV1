#include <Accelerate/Accelerate.h>
#include <stdio.h>
int main() {
    float A[1], B[1], C[1];
    printf("Calling cblas_sgemm with K=0 lda=1...\n");
    cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, 1, 1, 0, 1.0f, A, 1, B, 1, 1.0f, C, 1);
    printf("Done!\n");
    return 0;
}
