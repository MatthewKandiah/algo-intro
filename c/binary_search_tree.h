#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

typedef struct Node {
  int64_t key;
  struct Node *parent;
  struct Node *left;
  struct Node *right;
} Node;

bool is_binary_search_tree(Node *);
void print_in_order(Node *);
Node *rec_search(Node *, int64_t);
Node *itr_search(Node *, int64_t);
Node *minimum(Node *);
Node *maximum(Node *);
