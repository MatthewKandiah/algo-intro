#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

typedef struct {
  struct Node *root;
} BinarySearchTree;

typedef struct Node {
  int64_t key;
  struct Node *parent;
  struct Node *left;
  struct Node *right;
} Node;

bool is_binary_search_tree(Node *);
void print_in_order(Node *);
int count_nodes_in_tree(Node *);
Node *rec_search(Node *, int64_t);
Node *itr_search(Node *, int64_t);
Node *minimum(Node *);
Node *maximum(Node *);
Node *successor(Node *);   // get the next node visited in an ordered walk
Node *predecessor(Node *); // get the previous node visited in an ordered walk
void tree_insert(BinarySearchTree *, Node *);
void tree_transplant(BinarySearchTree *, Node *old_node,
                     Node *new_node); // replaces one subtree as the child of
                                      // its parent with another subtree
void tree_delete(BinarySearchTree *, Node *);
