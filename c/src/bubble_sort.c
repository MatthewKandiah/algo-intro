#include "../include/bubble_sort.h"
#include <stdio.h>

void bubble_sort(int32_t *numbers, int count) {
	for (int i = 0; i < count-1; i++) {
		for (int j = count; j > i; j--) {
			if (numbers[j] < numbers[j-1]) {
				int32_t tmp = numbers[j];
				numbers[j] = numbers[j-1];
				numbers[j-1] = tmp;
			}
		}
	}
}
