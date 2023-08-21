#include <stdio.h>
#include "../include/insertion_sort.h"

void insertion_sort(int32_t *numbers, int count) {
	for (int i = 1; i < count; i++) {
		int32_t key = numbers[i];
		int j = i - 1;
		while (j >= 0 && numbers[j] > key) {
			numbers[j+1] = numbers[j];
			j--;
		}
		numbers[j+1] = key;
	}
}
