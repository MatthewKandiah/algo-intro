#include <stdio.h>

struct Heap {
  int heapSize;
  int arraySize;
  int *array;
};

int parentIndex(int heapNodeIndex) { return ((1 + heapNodeIndex) / 2) - 1; }

int leftIndex(int heapNodeIndex) { return 2 * (heapNodeIndex + 1) - 1; }

int rightIndex(int heapNodeIndex) { return leftIndex(heapNodeIndex) + 1; }

int isValidHeapNodeIndex(struct Heap heap, int i) { return heap.heapSize > i; }

// take array A, inspect index i, assuming its children are the roots of
// max-heaps we do not assume that A[i] obeys the max-heap property rearrange
// elements such that A[i] and below defines a max-heap requires recursively
// checking down the branch we swap into because we might break its max-heap
// property when we swap a smaller value into its root
void maxHeapify(struct Heap A, int i) {
  int l = leftIndex(i);
  int r = rightIndex(i);

  int largest;
  if (isValidHeapNodeIndex(A, l) && A.array[l] > A.array[i]) {
    largest = l;
  } else {
    largest = i;
  }
  if (isValidHeapNodeIndex(A, r) && A.array[r] > A.array[largest]) {
    largest = r;
  }
  if (largest != i) {
    int Ai = A.array[i];
    A.array[i] = A.array[largest];
    A.array[largest] = Ai;
    maxHeapify(A, largest);
  }
}

struct Heap buildMaxHeap(int *array, int numberOfElements) {
  int heapArray[numberOfElements];
  for (int i = 0; i < numberOfElements; i++) {
    heapArray[i] = array[i];
  }
  struct Heap result = {numberOfElements, numberOfElements, heapArray};
  for (int i = numberOfElements / 2; i >= 0; i--) {
    maxHeapify(result, i);
  }
  return result;
}

void heapSort(int *array, int arrayLength) {
  struct Heap heap = buildMaxHeap(array, arrayLength);
  for (int i = arrayLength - 1; i >= 1; i--) {
    int Ai = heap.array[i];
    heap.array[i] = heap.array[0];
    heap.array[0] = Ai;
    heap.heapSize--;
    maxHeapify(heap, 0);
  }

  for (int i = 0; i < arrayLength; i++) {
    array[i] = heap.array[i];
  }
}

void printArray(int *array, int length) {
  for (int i = 0; i < length; ++i) {
    printf("%d ", array[i]);
  }
  printf("%c", '\n');
}

int main() {
  int numbers[] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
  int numbersLength = sizeof(numbers) / sizeof(numbers[0]);
  printArray(numbers, numbersLength);
  heapSort(numbers, numbersLength);
  printArray(numbers, numbersLength);
  return 0;
}
