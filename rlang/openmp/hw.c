// verifying that OMP environment actually works

#include <omp.h>
#include <stdio.h>

int main() {
#pragma omp parallel
  {
    int x = 0;
    printf("%d\n", x + 1);
    printf("Hello from %d\n", omp_get_thread_num());
  }
}
