#include <stdio.h>

void print_array(const int array[], const int length) {
  for (int i = 0; i < length; ++i) {
    printf("%d ", array[i]);
  }
  printf("%c", '\n');
}

int main() {
  // TODO - it would be nice to come back and make this take command line arguments instead of a hardcoded array
  int unsortedArray[] = {2, 1, 4, 5, 3};
  int numberOfElements = sizeof(unsortedArray) / sizeof(unsortedArray[0]);

  printf("Unsorted array: \n\t");
  print_array(unsortedArray, numberOfElements);

  int result[numberOfElements];
  result[0] = unsortedArray[0];
  int insertedElements = 1;

  while (insertedElements < numberOfElements) {
    int currentElement = unsortedArray[insertedElements];
    int compareIndex = insertedElements - 1;

    while (compareIndex >= 0 && result[compareIndex] > currentElement) {
      result[compareIndex + 1] = result[compareIndex];
      compareIndex--;
    }
    result[compareIndex + 1] = currentElement;

    insertedElements++;
  }

  printf("Sorted array: \n\t");
  print_array(result, sizeof(result) / sizeof(result[0]));

  return 0;
}
