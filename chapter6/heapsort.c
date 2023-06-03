#include <stdio.h>

void printArray(int *array, int arrayLength) {
  for (int i = 0; i < arrayLength; i++) {
    printf("%d ", array[i]);
  }
  printf("%c", '\n');
}

typedef struct {
  // note - Heap.size does not necessarily equal the total array size
  //        it is the size of the sub-array that is a max-heap
  int size;
  int *array;
} Heap;

/*
 * max-heap:
 * - heap.array[0] is the largest value in the heap.
 * - every value in the heap is larger than or equal to its children
 * - heap.array[0] has two children, a left child at index 1, a right child at
 * index 2.
 * - heap.array[1] has two children, a left child at index 3, a right child at
 * index 4.
 * - heap.array[2] has two children, a left child at index 5, a right child at
 * index 6.
 * - this pattern continues -> heap.array[i] has a left child at index 2i+1, and
 * a right child at index 2i+2
 * - the reverse works too -> heap.array[i] has a parent at index floor((i+1)/2)
 * - 1
 */

int leftIndex(int heapIndex) { return 2 * heapIndex + 1; }

int rightIndex(int heapIndex) { return 2 * heapIndex + 2; }

// note - integer division floors floating point values
int parentIndex(int heapIndex) { return ((heapIndex + 1) / 2) - 1; }

int isValidHeapIndex(int heapIndex, Heap heap) {
  return heapIndex >= 0 && heapIndex < heap.size;
}

// for debugging
int isMaxHeap(Heap heap) {
  for (int i = 0; i < heap.size; i++) {
    int l = leftIndex(i);
    int r = rightIndex(i);
    if (isValidHeapIndex(l, heap) && heap.array[l] > heap.array[i]) {
      return 0;
    }
    if (isValidHeapIndex(r, heap) && heap.array[r] > heap.array[i]) {
      return 0;
    }
  }
  return 1;
}

// assume left and right children of element indexed i are roots of valid
// max-heaps so the only illegal element is our route at index i rearrange
// elements so that we then have a valid max heap
void maxHeapify(Heap heap, int i) {
  int l = leftIndex(i);
  int r = rightIndex(i);

  int largest;
  if (isValidHeapIndex(l, heap) && heap.array[l] > heap.array[i]) {
    largest = l;
  } else {
    largest = i;
  }
  if (isValidHeapIndex(r, heap) && heap.array[r] > heap.array[largest]) {
    largest = r;
  }

  if (largest != i) {
    // swap root with largest, then check if that branch is still a max-heap
    int temp = heap.array[i];
    heap.array[i] = heap.array[largest];
    heap.array[largest] = temp;
    maxHeapify(heap, largest);
  }
}

// rearrange array into a max-heap & return Heap object
Heap buildMaxHeap(int *array, int arrayLength) {
  Heap heap = {arrayLength, array};
  int highestIndexThatMayNotBeLeafElement = arrayLength / 2;
  for (int i = highestIndexThatMayNotBeLeafElement; i >= 0; i--) {
    maxHeapify(heap, i);
  }
  return heap;
}

void heapSort(int *array, int arrayLength) {
  Heap heap = buildMaxHeap(array, arrayLength);
  for (int i = arrayLength-1; i > 0; i--) {
    int temp = array[0];
    array[0] = array[i];
    array[i] = temp;
    heap.size--;
    maxHeapify(heap, 0);
  }
}

int main() {
  int numbers[] = {2, 8, 7, 4, 6, 3, 0, 8, 9, 2, 1, 3};
  int numbersLength = sizeof(numbers) / sizeof(numbers[0]);
  printf("Unsorted numbers\n\t");
  printArray(numbers, numbersLength);
  heapSort(numbers, numbersLength);
  printf("Sorted numbers\n\t");
  printArray(numbers, numbersLength);
  return 0;
}
