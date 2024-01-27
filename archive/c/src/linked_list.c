#include "../include/linked_list.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

LinkedList linkedListInit(int32_t *numbers, int count) {
	LinkedList list = {.head=0};
	for (int i = 0; i < count; i++) {
		linkedListPrepend(&list, *numbers);
		numbers++;
	}
	linkedListReverse(&list);
	return list;
}

void linkedListDeinit(LinkedList list) {
	LinkedListNode *currentNode = list.head;
	while (currentNode) {
		LinkedListNode *next = currentNode->next;
		free(currentNode);
		currentNode = next;
	}
}

void linkedListPrint(LinkedList list) {
	LinkedListNode *currentNode = list.head;
	while (1) {
		printf("%d, ", currentNode->key);
		currentNode = currentNode->next;
		if (!currentNode) {
			break;
		}
	}
}

void linkedListPrepend(LinkedList *list, int32_t value) {
	LinkedListNode *newNodePtr = malloc(sizeof(LinkedListNode));
	newNodePtr->key = value;
	newNodePtr->next = list->head;
	newNodePtr->prev = 0;
	if (list->head) {
		list->head->prev = newNodePtr;
	}
	list->head = newNodePtr;
}

// assume no cycles for simplicity
void linkedListReverse(LinkedList *list) {
	LinkedListNode *currentNodePtr = list->head;
	if (!currentNodePtr) {
		return;
	}
	while (1) {
		LinkedListNode *nextNodePtr = currentNodePtr->next;
		currentNodePtr->next = currentNodePtr->prev;
		currentNodePtr->prev = nextNodePtr;
		if (nextNodePtr) {
			currentNodePtr = nextNodePtr;
		} else {
			list->head = currentNodePtr;
			break;
		}
	}
}

LinkedListNode *linkedListSearch(LinkedList list, int32_t value) {
	LinkedListNode *currentNode = list.head;
	while (currentNode) {
		if (currentNode->key == value) {
			return currentNode;
		}
		currentNode = currentNode->next;
	}
	return 0;
}

void linkedListNodeInsert(LinkedListNode *existingNode, LinkedListNode *newNode) {
	if (existingNode->next) {
		existingNode->next->prev = newNode;
	}

	newNode->next = existingNode->next;
	newNode->prev = existingNode;

	existingNode->next = newNode;
}
