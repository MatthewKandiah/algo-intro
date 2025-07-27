#include "./binary_search_tree.h"
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

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
