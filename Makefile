CC = gcc
CFLAGS = -g

all: insertion_sort merge_sort hybrid_merge_insertion_sort test

clean:
	rm -rf obj bin
	mkdir obj bin

test: src/test.c
	${CC} ${CFLAGS} src/test.c obj/insertion_sort.o obj/merge_sort.o obj/hybrid_merge_insertion_sort.o -o bin/test

insertion_sort: src/insertion_sort.c
	${CC} ${CFLAGS} -c src/insertion_sort.c -o obj/insertion_sort.o

merge_sort: src/merge_sort.c
	${CC} ${CFLAGS} -c src/merge_sort.c -o obj/merge_sort.o

hybrid_merge_insertion_sort: src/hybrid_merge_insertion_sort.c
	${CC} ${CFLAGS} -c src/hybrid_merge_insertion_sort.c -o obj/hybrid_merge_insertion_sort.o
