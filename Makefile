CC = gcc
CFLAGS = -g

all: insertion_sort test

clean:
	rm -rf obj bin
	mkdir obj bin

test: src/test.c obj/insertion_sort.o
	${CC} ${CFLAGS} src/test.c obj/insertion_sort.o -o bin/test


insertion_sort: src/insertion_sort.c
	${CC} ${CFLAGS} -c src/insertion_sort.c -o obj/insertion_sort.o
