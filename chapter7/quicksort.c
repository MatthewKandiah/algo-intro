#include <stdio.h>

void printArray(int* array, int arrayLength) {
  for (int i = 0; i < arrayLength; i++) {
    printf("%d ", array[i]);
  }
  printf("%c", '\n');
}

void quickSort(int* array, int arrayLength) {}

int main() {
  int numbers[] = {5,4,3,2,1};
  int numbersLength = sizeof(numbers) / sizeof(numbers[0]);
  printf("Unsorted numbers\n\t");
  printArray(numbers, numbersLength);
  
  quickSort(numbers, numbersLength);

  printf("Sorted numbers\n\t");
  printArray(numbers, numbersLength);
}
