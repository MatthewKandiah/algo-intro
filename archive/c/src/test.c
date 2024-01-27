#include "../include/bubble_sort.h"
#include "../include/heap_sort.h"
#include "../include/hybrid_merge_insertion_sort.h"
#include "../include/insertion_sort.h"
#include "../include/merge_sort.h"
#include "../include/stack.h"
#include "../include/linked_list.h"
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

#define MAX_TEST_NUMBER 1000

const int test_array_sizes[] = {ARRAY0_SIZE, ARRAY1_SIZE, ARRAY2_SIZE,
                                ARRAY3_SIZE, ARRAY4_SIZE, ARRAY5_SIZE,
                                ARRAY6_SIZE, ARRAY7_SIZE};

void populate_with_random_ints(int32_t *numbers, int count) {
  for (int i = 0; i < count; i++) {
    *numbers = random() % MAX_TEST_NUMBER;
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

void verify_linked_list(LinkedList list, int32_t *numbers, int count) {
  int test_failed = 0;
  int too_many_elements = 0;
  int element_index = 0;
  LinkedListNode *currentNode = list.head;
  while (1) {
    if (element_index < count && !currentNode) {
      test_failed = 1;
      break;
    }
    if (element_index >= count) {
      if (currentNode) {
        test_failed = 1;
        too_many_elements = 1;
      }
      break;
    }
    if (currentNode->key != numbers[element_index]) {
      test_failed = 1;
      break;
    }
    currentNode = currentNode->next;
    element_index++;
  }

  if (!test_failed) {
    printf("\tTest passed!\n");
  } else {
    printf("\tTest failed:\n");
    if(too_many_elements) {
      printf("\ttoo many elements\n");
    }
    printf("\texpected: ");
    for (int i = 0; i < count; i++) {
      printf("%d, ", numbers[i]);
    }
    printf("\n\treceived: ");
    linkedListPrint(list);
    printf("\n");
  }
}

int main() {
  time_t t;
  srand(time(&t));

  printf("Sorting Algorithm tests:\n");
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
  test_sort_function(test_arrays, hybrid_merge_insertion_sort,
                     "Hybrid Merge-Insertion Sort:");
  test_sort_function(test_arrays, bubble_sort, "Bubble Sort:");
  test_sort_function(test_arrays, heap_sort, "Heap Sort:");

  printf("Data structure tests:\n");
  printf("Stack:\n");
  stack s5 = stack_init(5);
  int s5TestFailed = 0;
  printf("\tinitialisation...\n");
  if (!stack_empty(s5)) {
    printf("\tERROR: stack should initialise empty\n");
    s5TestFailed = 1;
  }
  printf("\tpushing & popping - not to capacity...\n");
  stack_push(&s5, 1);
  stack_push(&s5, 2);
  stack_push(&s5, 3);
  int32_t firstPop = stack_pop(&s5);
  int32_t secondPop = stack_pop(&s5);
  if (stack_empty(s5)) {
    printf("\tERROR: stack should not be empty\n");
    s5TestFailed = 1;
  }
  if (stack_full(s5)) {
    printf("\tERROR: stack should not be full\n");
  }
  printf("\tpushing & popping - to capacity...\n");
  stack_push(&s5, 4);
  stack_push(&s5, 5);
  stack_push(&s5, 6);
  stack_push(&s5, 7);
  if (!stack_full(s5)) {
    printf("\tERROR: stack should be full\n");
    s5TestFailed = 1;
  }
  int32_t thirdPop = stack_pop(&s5);
  int32_t fourthPop = stack_pop(&s5);
  int32_t fifthPop = stack_pop(&s5);
  int32_t sixthPop = stack_pop(&s5);
  int32_t seventhPop = stack_pop(&s5);
  if (!stack_empty(s5)) {
    printf("\tError: stack should be empty\n");
    s5TestFailed = 1;
  }
  printf("\tpopped values...\n");
  if (!(firstPop == 3 && secondPop == 2 && thirdPop == 7 && fourthPop == 6 && fifthPop == 5 && sixthPop == 4 && seventhPop == 1)) {
    printf("\tERROR: incorrect popped values\n");
    s5TestFailed = 1;
  }
  if (!s5TestFailed) {
    printf("\tAll tests passed!\n");
  }

  printf("Linked List:\n");
  printf("\tinitialisation...\t");
  int32_t numbers[] = {1,2,3,4};
  LinkedList linkedList = linkedListInit(numbers, 4);
  verify_linked_list(linkedList, numbers, sizeof(numbers) / sizeof(int32_t));
  printf("\tprepending...\t\t");
  linkedListPrepend(&linkedList, 0);
  int32_t prependedNumbers[] = {0,1,2,3,4};
  verify_linked_list(linkedList, prependedNumbers, sizeof(prependedNumbers)/sizeof(int32_t));
  printf("\tsearching & inserting...\t");
  LinkedListNode *node2 = linkedListSearch(linkedList, 2);
  LinkedListNode *insertNode = malloc(sizeof(LinkedListNode));
  insertNode->key = 7;
  linkedListNodeInsert(node2, insertNode);
  int32_t insertedNumbers[] = {0,1,2,7,3,4};
  verify_linked_list(linkedList, insertedNumbers, sizeof(insertedNumbers)/sizeof(int32_t));

  linkedListDeinit(linkedList);
  return 0;
}