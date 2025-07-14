#include "./binary_search_tree.h"
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main(void) {
  Node example2 = {
      .key = 2,
  };
  Node example5a = {
      .key = 5,
  };
  Node example8 = {
      .key = 8,
  };
  Node example5b = {
      .key = 5,
  };
  Node example7 = {
      .key = 7,
  };
  Node example6 = {
      .key = 6,
  };

  example6.left = &example5b;
  example6.right = &example7;

  example5b.parent = &example6;
  example5b.left = &example2;
  example5b.right = &example5a;

  example7.parent = &example6;
  example7.right = &example8;

  example2.parent = &example5b;

  example5a.parent = &example5b;

  example8.parent = &example7;

  printf("print_in_order\n");
  print_in_order(&example6);

  printf("\n");
  printf("rec_search\n");
  Node *rec_search2_res = rec_search(&example6, 2);
  Node *rec_search5_res = rec_search(&example6, 5);
  Node *rec_search8_res = rec_search(&example6, 8);
  printf("rec_search2_res as expected: %d\n", rec_search2_res == &example2);
  printf("rec_search5_res as expected: %d\n", rec_search5_res == &example5b);
  printf("rec_search8_res as expected: %d\n", rec_search8_res == &example8);

  printf("\n");
  printf("itr_search\n");
  Node *itr_search2_res = itr_search(&example6, 2);
  Node *itr_search5_res = itr_search(&example6, 5);
  Node *itr_search8_res = itr_search(&example6, 8);
  printf("itr_search2_res as expected: %d\n", itr_search2_res == &example2);
  printf("itr_search5_res as expected: %d\n", itr_search5_res == &example5b);
  printf("itr_search8_res as expected: %d\n", itr_search8_res == &example8);

  printf("\n");
  printf("maximum as expected: %d\n", maximum(&example6) == &example8);
  printf("minimum as expected: %d\n", minimum(&example6) == &example2);

  printf("\n");
  printf("successor of 2 as expected: %d\n", successor(&example2) == &example5b);
  printf("successor of 5b as expected: %d\n", successor(&example5b) == &example5a);
  printf("successor of 5a as expected: %d\n", successor(&example5a) == &example6);
  printf("successor of 6 as expected: %d\n", successor(&example6) == &example7);
  printf("successor of 7 as expected: %d\n", successor(&example7) == &example8);
  printf("successor of 8 as expected: %d\n", successor(&example8) == NULL);

  printf("\n");
  printf("predecessor of 2 as expected: %d\n", predecessor(&example2) == NULL);
  printf("predecessor of 5b as expected: %d\n", predecessor(&example5b) == &example2);
  printf("predecessor of 5a as expected: %d\n", predecessor(&example5a) == &example5b);
  printf("predecessor of 6 as expected: %d\n", predecessor(&example6) == &example5a);
  printf("predecessor of 7 as expected: %d\n", predecessor(&example7) == &example6);
  printf("predecessor of 8 as expected: %d\n", predecessor(&example8) == &example7);
}

bool is_binary_search_tree(Node *root) {
  if (!root) {
    return false;
  }

  bool left_satisfies = true;
  if (root->left) {
    left_satisfies =
        root->left->key <= root->key && is_binary_search_tree(root->left);
  }

  bool right_satisfies = true;
  if (root->right) {
    right_satisfies =
        root->right->key >= root->key && is_binary_search_tree(root->right);
  }

  return left_satisfies && right_satisfies;
}

void print_in_order(Node *root) {
  if (!root) {
    return;
  }
  print_in_order(root->left);
  printf("%ld\n", root->key);
  print_in_order(root->right);
}

Node *rec_search(Node *node, int64_t value) {
  if (!node || node->key == value) {
    return node;
  }
  if (value < node->key) {
    return rec_search(node->left, value);
  }
  return rec_search(node->right, value);
}

Node *itr_search(Node *node, int64_t value) {
  while (node && node->key != value) {
    if (value < node->key) {
      node = node->left;
    } else {
      node = node->right;
    }
  }
  return node;
}

Node *minimum(Node *node) {
  while (node && node->left) {
    node = node->left;
  }
  return node;
}

Node *maximum(Node *node) {
  while (node && node->right) {
    node = node->right;
  }
  return node;
}

Node *successor(Node *node) {
  if (!node) {
    fprintf(stderr, "ASSERT: cannot find successor of nil pointer");
    exit(1);
  }
  if (node->right) {
    return minimum(node->right);
  }
  Node *parent_node = node->parent;
  while (parent_node && node->key == parent_node->right->key) {
    node = parent_node;
    parent_node = parent_node->parent;
  }
  return parent_node;
}

Node *predecessor(Node *node) {
  if (!node) {
    fprintf(stderr, "ASSERT: cannot find predessor of nil pointer");
    exit(1);
  }
  if (node->left) {
    return maximum(node->left);
  }
  Node *parent_node = node->parent;
  while (parent_node && node->key == parent_node->left->key) {
    node = parent_node;
    parent_node = parent_node->parent;
  }
  return parent_node;
}

