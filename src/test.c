#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define TEST_ARRAY_COUNT 6
#define ARRAY0_SIZE 10
#define ARRAY1_SIZE 100
#define ARRAY2_SIZE 1000
#define ARRAY3_SIZE 10000
#define ARRAY4_SIZE 100000
#define ARRAY5_SIZE 1000000

void populate_with_random_ints(int32_t *numbers, int count) {
  int i = 0;
  for (i = 0; i < count; i++) {
    *numbers = random();
    numbers++;
  }
}

void randomise_test_arrays(int32_t **test_arrays, int count) {
  const int test_array_sizes[] = {ARRAY0_SIZE, ARRAY1_SIZE, ARRAY2_SIZE,
                                  ARRAY3_SIZE, ARRAY4_SIZE, ARRAY5_SIZE};
  for (int i = 0; i < count; i++) {
    populate_with_random_ints(test_arrays[i], test_array_sizes[i]);
  }
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
  test_arrays[0] = array0;
  test_arrays[1] = array1;
  test_arrays[2] = array2;
  test_arrays[3] = array3;
  test_arrays[4] = array4;
  test_arrays[5] = array5;

  printf("%s", "first run");
  randomise_test_arrays(test_arrays, TEST_ARRAY_COUNT);
  for (int i = 0; i < 10; i++) {
    printf("%d \n", test_arrays[0][i]);
  }
  printf("%s", "second run");
  randomise_test_arrays(test_arrays, TEST_ARRAY_COUNT);
  for (int i = 0; i < 10; i++) {
    printf("%d \n", test_arrays[0][i]);
  }
  return 0;
}
