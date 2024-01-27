#include <stdint.h>

typedef struct LinkedListNode {
  int32_t key;
  struct LinkedListNode *prev;
  struct LinkedListNode *next;
} LinkedListNode;

typedef struct LinkedList {
  LinkedListNode *head;
} LinkedList;

LinkedList linkedListInit(int32_t *, int);

void linkedListDeinit(LinkedList);

void linkedListPrint(LinkedList);

void linkedListPrepend(LinkedList *, int32_t);

void linkedListReverse(LinkedList *);

LinkedListNode *linkedListSearch(LinkedList, int32_t);

void linkedListNodeInsert(LinkedListNode *, LinkedListNode *);

