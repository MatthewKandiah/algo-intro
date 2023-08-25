#include "../include/merge_sort.h"
#include <stdio.h>
#include <stdlib.h>

void merge(int32_t *numbers, int x, int y, int z) {
	int nl = y - x;
	int nr = z - y;

	int32_t *l = malloc(nl * sizeof(int32_t));
	for (int i = 0; i < nl; i++) {
		l[i] = numbers[x + i];
	}
	int32_t *r = malloc(nr * sizeof(int32_t));
	for (int i = 0; i < nr; i++) {
		r[i] = numbers[y + i];
	}

	int l_pos = 0;
	int r_pos = 0;
	int fill_pos = x;

	while (l_pos < nl && r_pos < nr) {
		if (l[l_pos] < r[r_pos]) {
			numbers[fill_pos] = l[l_pos];
			l_pos++;
		} else {
			numbers[fill_pos] = r[r_pos];
			r_pos++;
		}
		fill_pos++;
	}

	while (l_pos < nl) {
		numbers[fill_pos] = l[l_pos];
		l_pos++;
		fill_pos++;
	}

	while (r_pos < nr) {
		numbers[fill_pos] = r[r_pos];
		r_pos++;
		fill_pos++;
	}

	free(l);
	free(r);
}

void merge_sort_range(int32_t *numbers, int x, int z) {
	if (z-x == 1) {
		// base case - single element
		return;
	}
	int y = (x + z) /2;
	merge_sort_range(numbers, x, y);
	merge_sort_range(numbers, y,z);
	merge(numbers, x, y, z);
}

void merge_sort(int32_t *numbers, int count) {
	merge_sort_range(numbers, 0, count);
}
