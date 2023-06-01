CC=gcc
CFLAGS=-g

all: insertion_sort merge_sort

insertion_sort: insertion_sort.c
	$(CC) $(CFLAGS) -o insertion_sort.o insertion_sort.c

merge_sort: merge_sort.c
	$(CC) $(CFLAGS) -o merge_sort.o merge_sort.c

clean:
	rm insertion_sort.o merge_sort.o

