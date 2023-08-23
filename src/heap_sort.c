#include <stdint.h>
#include <stdio.h>

int heap_parent_index(int i) { return ((i + 1) / 2) - 1; }

int heap_left_index(int i) { return 2 * (i + 1) - 1; }

int heap_right_index(int i) { return 2 * (i + 1); }

void max_heapify(int32_t *numbers, int count, int i) {
  int l = heap_left_index(i);
  int r = heap_right_index(i);

  int largest;
  if (l < count && numbers[l] > numbers[i]) {
    largest = l;
  } else {
    largest = i;
  }
  if (r < count && numbers[r] > numbers[largest]) {
    largest = r;
  }

  if (largest != i) {
    int32_t tmp = numbers[i];
    numbers[i] = numbers[largest];
    numbers[largest] = tmp;
    max_heapify(numbers, count, largest);
  }
}

void build_max_heap(int32_t *numbers, int count) {
  for (int i = (count - 1) / 2; i >= 0; i--) {
    max_heapify(numbers, count, i);
  }
}

void heap_sort(int32_t *numbers, int count) {
  int heap_size = count;
  build_max_heap(numbers, heap_size);
  for (int i = count - 1; i > 0; i--) {
    int32_t tmp = numbers[0];
    numbers[0] = numbers[i];
    numbers[i] = tmp;
    heap_size--;
    max_heapify(numbers, heap_size, 0);
  }
}

