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
  printf("successor of 2 as expected: %d\n",
         successor(&example2) == &example5b);
  printf("successor of 5b as expected: %d\n",
         successor(&example5b) == &example5a);
  printf("successor of 5a as expected: %d\n",
         successor(&example5a) == &example6);
  printf("successor of 6 as expected: %d\n", successor(&example6) == &example7);
  printf("successor of 7 as expected: %d\n", successor(&example7) == &example8);
  printf("successor of 8 as expected: %d\n", successor(&example8) == NULL);

  printf("\n");
  printf("predecessor of 2 as expected: %d\n", predecessor(&example2) == NULL);
  printf("predecessor of 5b as expected: %d\n",
         predecessor(&example5b) == &example2);
  printf("predecessor of 5a as expected: %d\n",
         predecessor(&example5a) == &example5b);
  printf("predecessor of 6 as expected: %d\n",
         predecessor(&example6) == &example5a);
  printf("predecessor of 7 as expected: %d\n",
         predecessor(&example7) == &example6);
  printf("predecessor of 8 as expected: %d\n",
         predecessor(&example8) == &example7);

  int random_ints_count = 1000;
  int64_t *random_ints = malloc(random_ints_count);
  Node *nodes = malloc(random_ints_count);
  BinarySearchTree tree = {0};
  for (int i = 0; i < random_ints_count; ++i) {
    nodes[i].key = random_ints[i];
    tree_insert(&tree, &nodes[i]);
  }
  printf("tree generated by repeated inserts is valid: %d\n",
         is_binary_search_tree(tree.root));
  printf("nodes in tree: %d\n", count_nodes_in_tree(tree.root));

  bool node_deletion_working_as_expected = true;
  int expected_tree_node_count = random_ints_count;
  for (int i = 0; i < random_ints_count; ++i) {
    tree_delete(&tree, &nodes[i]);
    expected_tree_node_count -= 1;
    node_deletion_working_as_expected =
        is_binary_search_tree(tree.root) &&
        count_nodes_in_tree(tree.root) == expected_tree_node_count;
  }
  printf("node deletion working as expected: %d\n", node_deletion_working_as_expected);
  printf("tree is empty: %d\n", tree.root == NULL);
}

bool is_binary_search_tree(Node *root) {
  if (!root) {
    // empty tree is a valid tree
    return true;
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

int count_nodes_in_tree(Node *node) {
  if (!node) {
    return 0;
  }
  return count_nodes_in_tree(node->left) + count_nodes_in_tree(node->right) + 1;
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
  while (parent_node && parent_node->left &&
         node->key == parent_node->left->key) {
    node = parent_node;
    parent_node = parent_node->parent;
  }
  return parent_node;
}

void tree_insert(BinarySearchTree *tree, Node *new_node) {
  Node *cmp_node = tree->root;
  Node *parent_node = NULL;
  // descend to find leaf node to attach to
  while (cmp_node) {
    parent_node = cmp_node;
    if (new_node->key < cmp_node->key) {
      cmp_node = cmp_node->left;
    } else {
      cmp_node = cmp_node->right;
    }
  }
  // correct leaf node found
  new_node->parent = parent_node;
  if (!parent_node) {
    // tree was empty
    tree->root = new_node;
  } else if (new_node->key < parent_node->key) {
    parent_node->left = new_node;
  } else {
    parent_node->right = new_node;
  }
}

void generate_random_ints(int64_t *buf, int count) {
  for (int i = 0; i < count; ++i) {
    buf[i] = rand();
  }
}

void tree_transplant(BinarySearchTree *tree, Node *old_node, Node *new_node) {
  if (!old_node) {
    fprintf(stderr, "ASSERT: old_node cannot be nil pointer");
    exit(1);
  }
  if (!old_node->parent) {
    tree->root = new_node;
  } else if (old_node == old_node->parent->left) {
    old_node->parent->left = new_node;
  } else {
    old_node->parent->right = new_node;
  }
  if (new_node) {
    new_node->parent = old_node->parent;
  }
}

void tree_delete(BinarySearchTree *tree, Node *delete_node) {
  if (!delete_node) {
    fprintf(stderr, "ASSERT: delete_node cannot be nil pointer");
    exit(1);
  }
  if (!delete_node->left && !delete_node->right) {
    tree_transplant(tree, delete_node, NULL);
  } else if (!delete_node->left && delete_node->right) {
    tree_transplant(tree, delete_node, delete_node->right);
  } else if (delete_node->left && !delete_node->right) {
    tree_transplant(tree, delete_node, delete_node->left);
  } else {
    // delete_node has left and right children
    Node *successor = minimum(delete_node->right);
    if (successor != delete_node->right) {
      tree_transplant(tree, successor, successor->right);
      successor->right = delete_node->right;
      successor->right->parent = successor;
    }
    tree_transplant(tree, delete_node, successor);
    successor->left = delete_node->left;
    successor->left->parent = successor;
  }
}
