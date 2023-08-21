#include "../include/insertion_sort.h"
#include "../include/merge_sort.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define TEST_ARRAY_COUNT 8
#define ARRAY0_SIZE 10
#define ARRAY1_SIZE 11
#define ARRAY2_SIZE 100
#define ARRAY3_SIZE 101
#define ARRAY4_SIZE 1000
#define ARRAY5_SIZE 1001
#define ARRAY6_SIZE 10000
#define ARRAY7_SIZE 10001

const int test_array_sizes[] = {ARRAY0_SIZE, ARRAY1_SIZE, ARRAY2_SIZE,
                                ARRAY3_SIZE, ARRAY4_SIZE, ARRAY5_SIZE,
                                ARRAY6_SIZE, ARRAY7_SIZE};

void populate_with_random_ints(int32_t *numbers, int count) {
  for (int i = 0; i < count; i++) {
    *numbers = random();
    numbers++;
  }
}

void randomise_test_arrays(int32_t **test_arrays) {
  for (int i = 0; i < TEST_ARRAY_COUNT; i++) {
    populate_with_random_ints(test_arrays[i], test_array_sizes[i]);
  }
}

typedef void (*sort_function)(int32_t *, int);
void apply_sort_function(int32_t **test_arrays, sort_function sort_function) {
  for (int i = 0; i < TEST_ARRAY_COUNT; i++) {
    sort_function(test_arrays[i], test_array_sizes[i]);
  }
}

int is_sorted(int32_t *array, int count) {
  for (int i = 0; i < count - 1; i++) {
    if (array[i] > array[i + 1]) {
      return 0;
    }
  }
  return 1;
}

void report_test_results(int32_t **sorted_test_arrays, char *message) {
  int failure_count = 0;
  printf("%s\n", message);
  for (int i = 0; i < TEST_ARRAY_COUNT; i++) {
    int correctly_sorted =
        is_sorted(sorted_test_arrays[i], test_array_sizes[i]);
    if (!correctly_sorted) {
      failure_count++;
      printf("\tIncorrectly sorted for %d\n", i);
    }
  }
  if (failure_count != 0) {
    printf("\t%d tests failed!\n\n", failure_count);
  } else {
    printf("\tAll tests passed!\n\n");
  }
}

void test_sort_function(int32_t **test_arrays, sort_function sort_function,
                        char *message) {
  randomise_test_arrays(test_arrays);
  apply_sort_function(test_arrays, sort_function);
  report_test_results(test_arrays, message);
}

int main() {
  time_t t;
  srand(time(&t));

  int32_t *test_arrays[TEST_ARRAY_COUNT];
  int32_t array0[ARRAY0_SIZE];
  int32_t array1[ARRAY1_SIZE];
  int32_t array2[ARRAY2_SIZE];
  int32_t array3[ARRAY3_SIZE];
  int32_t array4[ARRAY4_SIZE];
  int32_t array5[ARRAY5_SIZE];
  int32_t array6[ARRAY6_SIZE];
  int32_t array7[ARRAY7_SIZE];
  test_arrays[0] = array0;
  test_arrays[1] = array1;
  test_arrays[2] = array2;
  test_arrays[3] = array3;
  test_arrays[4] = array4;
  test_arrays[5] = array5;
  test_arrays[6] = array6;
  test_arrays[7] = array7;

  test_sort_function(test_arrays, insertion_sort, "Insertion Sort:");
  test_sort_function(test_arrays, merge_sort, "Merge Sort:");

  return 0;
}
