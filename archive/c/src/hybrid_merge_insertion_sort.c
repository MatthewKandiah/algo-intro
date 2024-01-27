#include "../include/hybrid_merge_insertion_sort.h"
#include "../include/insertion_sort.h"
#include "../include/merge_sort.h"

#define MAXIMUM_INSERTION_SORT_LENGTH 10

void hybrid_sort_range(int32_t *numbers, int x, int z) {
	const int sub_list_length = z-x;
	if (sub_list_length <= MAXIMUM_INSERTION_SORT_LENGTH) {
		insertion_sort(numbers+x, sub_list_length);
		return;
	}
	int y = (x + z) /2;
	hybrid_sort_range(numbers, x, y);
	hybrid_sort_range(numbers, y,z);
	merge(numbers, x, y, z);
}

void hybrid_merge_insertion_sort(int32_t *numbers, int count) {
	hybrid_sort_range(numbers, 0, count);
}

