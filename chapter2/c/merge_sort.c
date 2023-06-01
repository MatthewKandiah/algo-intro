#include <stdio.h>

/*
 *  A: the list we wish to sort
 *  p: the lower bound of the range we are merging
 *  q: the mid-point of the range we are merging, rounded down
 *  r: the upper bound of the range we are merging
 *
 *  merge two sub-ranges of A such that A[p, r] is sorted in ascending order
 */
void merge(int A[], int p, int q, int r) {
  int lengthLeft = q - p + 1;
  int lengthRight = r - q;

  int leftArray[lengthLeft];
  for (int i = 0; i < lengthLeft; i++) {
    leftArray[i] = A[i];
  }
  int rightArray[lengthRight];
  for (int i = 0; i < lengthRight; i++) {
    rightArray[i] = A[q + i + 1];
  }

  int leftSmallestRemainingIndex = 0;
  int rightSmallestRemainingIndex = 0;
  int fillIndex = 0;

  // as long as each array contains an unmerged element, copy the smallest
  // unmerged element into A
  while (leftSmallestRemainingIndex < lengthLeft &&
         rightSmallestRemainingIndex < lengthRight) {
    if (leftArray[leftSmallestRemainingIndex] <=
        rightArray[rightSmallestRemainingIndex]) {
      A[fillIndex] = leftArray[leftSmallestRemainingIndex];
      leftSmallestRemainingIndex++;
    } else {
      A[fillIndex] = rightArray[rightSmallestRemainingIndex];
      rightSmallestRemainingIndex++;
    }
    fillIndex++;
  }

  // copy the remainder on to the end of A
  while (leftSmallestRemainingIndex < lengthLeft) {
    A[fillIndex] = leftArray[leftSmallestRemainingIndex];
    leftSmallestRemainingIndex++;
    fillIndex++;
  }
  while (rightSmallestRemainingIndex < lengthRight) {
    A[fillIndex] = rightArray[rightSmallestRemainingIndex];
    rightSmallestRemainingIndex++;
    fillIndex++;
  }
}

void mergeSort(int A[], int p, int r) {
  if (p >= r)
    return;            // zero or one element
  int q = (p + r / 2); // floored automatically because integer division
  mergeSort(A, p, q + 1);
  mergeSort(A, q + 1, r);
  merge(A, p, q, r);
}

void printArray(int array[], int arrayLength) {
  for (int i = 0; i < arrayLength; i++) {
    printf("%d ", array[i]);
  }
  printf("%c", '\n');
}

int main() {
  int array[] = {2, 4, 1, 3, 6, 7, 5};
  int numberOfElements = sizeof(array) / sizeof(array[0]);
  printf("unsortedArray:\n\t");
  printArray(array, numberOfElements);

  mergeSort(array, 0, numberOfElements);

  printf("sortedArray\n\t");
  printArray(array, numberOfElements);
}
