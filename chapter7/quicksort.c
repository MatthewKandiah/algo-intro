#include <stdio.h>

void printArray(int *array, int arrayLength) {
  for (int i = 0; i < arrayLength; i++) {
    printf("%d ", array[i]);
  }
  printf("%c", '\n');
}

// partition goes from [lowerBoundIndex, upperBoundIndex)
// just feels natural using inclusive lower bounds and exclusive upper bounds
int partition(int *array, int lowerBoundIndex, int upperBoundIndex) {
  int pivotIndex = upperBoundIndex - 1;
  int i = lowerBoundIndex - 1;
  for (int j = lowerBoundIndex; j < pivotIndex; j++) {
    // for every element other than the pivot
    if (array[j] <= array[pivotIndex]) {
      // this element belongs on the low side of the partition
      i++;
      int temp = array[i];
      array[i] = array[j];
      array[j] = temp;
    }
  }
  int pivot = array[pivotIndex];
  array[pivotIndex] = array[i + 1];
  array[i + 1] = pivot;
  return i + 1;
}

void quickSort(int *array, int lowerBoundIndex, int upperBoundIndex) {
  if (upperBoundIndex - lowerBoundIndex > 1) {
    // sub-array contains at least 2 element and needs sorting
    int pivotIndex = partition(array, lowerBoundIndex, upperBoundIndex);
    quickSort(array, lowerBoundIndex, pivotIndex);
    quickSort(array, pivotIndex + 1, upperBoundIndex);
  }
}

int main() {
  int numbers[] = {7,8,2,0,6,5,2,3,5,5,0,6,8,9,2,5,1};
  int numbersLength = sizeof(numbers) / sizeof(numbers[0]);
  printf("Unsorted numbers\n\t");
  printArray(numbers, numbersLength);

  quickSort(numbers, 0, numbersLength);

  printf("Sorted numbers\n\t");
  printArray(numbers, numbersLength);
}
