#include <stdio.h>

void printArray(int *array, int arrayLength) {
  for (int i = 0; i < arrayLength; ++i) {
    printf("%d ", array[i]);
  }
  printf("%c", '\n');
}

// A: complete array we are sorting - each step is sorting some sub-array A[p,
// r) p: inclusive lower bound index for left sub-array q: exclusive upper bound
// index for left sub-array / inclusive lower bound index for right sub-array r:
// exclusive upper bound index for right sub-array
void merge(int *A, int p, int q, int r) {
  int nL = q - p;
  int nR = r - q;

  int L[nL];
  for (int i = 0; i < nL; ++i) {
    L[i] = A[p + i];
  }
  int R[nR];
  for (int i = 0; i < nR; ++i) {
    R[i] = A[q + i];
  }

  int i = 0; // index of smallest remaining element in L
  int j = 0; // index of smallest remaining element in R
  int k = p; // index if location in A to fill

  // while L and R contain unmerged elements, copy the smallest unmerged element
  // into A
  while (i < nL && j < nR) {
    if (L[i] <= R[j]) {
      A[k] = L[i];
      i++;
    } else {
      A[k] = R[j];
      j++;
    }
    k++;
  }

  // L or R is empty, copy remainder of the other into A
  while (i < nL) {
    A[k] = L[i];
    i++;
    k++;
  }
  while (j < nR) {
    A[k] = R[j];
    j++;
    k++;
  }
}

void mergeSort(int *A, int p, int r) {
  // r - p == 1 when there is a single element in the sub-array -> base case as single-element sub-array is already sorted
  if (r - p <= 1) {
    return;
  }
  int q = (p + r) / 2; // automatically floored because integer division
  mergeSort(A, p, q); // merge sort left sub array
  mergeSort(A, q, r); // merge sort right sub array
  merge(A, p, q, r); // merge sorted sub arrays
}

int main() {
  int array[] = {6, 4, 3, 2, 8, 7, 3, 2, 1};
  int arrayLength = sizeof(array) / sizeof(array[0]);

  printf("Unsorted array:\n\t");
  printArray(array, arrayLength);

  mergeSort(array, 0, arrayLength);

  printf("Sorted array:\n\t");
  printArray(array, arrayLength);

  return 0;
}
