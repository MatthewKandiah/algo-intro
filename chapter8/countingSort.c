#include <stdio.h>

void printArray(int *array, int arrayLength) {
  for (int i = 0; i < arrayLength; i++) {
    printf("%d ", array[i]);
  }
  printf("%c", '\n');
}

// sort a list of integers containing a maximum value of `limit`
void countingSort(int *array, int arrayLength, int limit) {
  int result[arrayLength];
  int countingArray[limit + 1];

  for (int i = 0; i < limit + 1; i++) {
    countingArray[i] = 0;
  }
  for (int i = 0; i < arrayLength; i++) {
    countingArray[array[i]]++;
  }
  // countingArray[i] now contains the number of times i appears in array

  for (int i = 1; i < limit + 1; i++) {
    countingArray[i] += countingArray[i - 1];
  }
  // transformed to cumulative count
  // countingArray[i] now contains the number of elements less than or equal to
  // i in array

  for (int i = arrayLength - 1; i >= 0; i--) {
    // for each element in array, check how many element less than or equal to it exist in the array
    // then insert element into result at the last index that it could appear at consistent with the previous result
    // note - we have to shift some of the indices by 1 compared to the book because they've indexed arrays from 1 
    result[countingArray[array[i]] - 1] = array[i];
    // update our counting array so repeated values are handled sensibly
    countingArray[array[i]] -= 1;
  }

  for (int i = 0; i < arrayLength; i++) {
    array[i] = result[i];
  }
}

int main() {
  int numbers[] = {0, 2, 1, 3, 1, 2, 3, 2, 0, 0, 2, 1, 3};
  int numbersLength = sizeof(numbers) / sizeof(numbers[0]);
  int maxNumber = 3;
  printf("Unsorted numbers:\n\t");
  printArray(numbers, numbersLength);
  countingSort(numbers, numbersLength, maxNumber);
  printf("Sorted numbers:\n\t");
  printArray(numbers, numbersLength);
}
