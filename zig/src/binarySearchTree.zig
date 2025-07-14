const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn BinarySearchTree(comptime Key: type) type {
    return struct {
        root: ?*Node,

        pub const Node = struct {
            key: Key,
            parent: ?*Node,
            left: ?*Node,
            right: ?*Node,
        };

        const Self = @This();

        pub fn search(self: *const Self, key: Key) ?*Node {
            var current_node = self.root;
            while (current_node) |node| {
                if (key == node.key) {
                    return node;
                }
                if (key < node.key) {
                    current_node = node.left;
                } else {
                    current_node = node.right;
                }
            }
            return null;
        }

        pub fn minimum(self: *const Self) ?*Node {
            if (self.root) |root| {
                var current_node = root;
                while (current_node.left) |next_node| {
                    current_node = next_node;
                }
                return current_node;
            } else {
                return null;
            }
        }

        pub fn insert(self: *Self, new_node: *Node) void {
            var compare_node = self.root;
            var parent_node: ?*Node = null;
            while (compare_node) |cmp| {
                parent_node = cmp;
                if (new_node.key < cmp.key) {
                    compare_node = cmp.left;
                } else {
                    compare_node = cmp.right;
                }
            }
            new_node.parent = parent_node;
            if (parent_node) |pnt| {
                if (new_node.key < pnt.key) {
                    pnt.left = new_node;
                } else {
                    pnt.right = new_node;
                }
            } else {
                self.root = new_node;
            }
        }

        pub fn transplant(self: *Self, target: *Node, replacement: ?*Node) void {
            if (target.parent) |pnt| {
                if (pnt.left == target) {
                    pnt.left = replacement;
                } else {
                    pnt.right = replacement;
                }
            } else {
                self.root = replacement;
            }
            if (replacement) |rpl| {
                rpl.parent = target.parent;
            }
        }

        pub fn delete(self: *Self, delete_node: *Node) void {
            if (delete_node.left == null) {
                self.transplant(delete_node, delete_node.right);
            } else if (delete_node.right == null) {
                self.transplant(delete_node, delete_node.left);
            } else {
                const sub_tree = BinarySearchTree(Key){ .root = delete_node.right };
                var successor = sub_tree.minimum().?;
                if (successor != delete_node.right) {
                    self.transplant(successor, successor.right);
                    successor.right = delete_node.right;
                    successor.right.?.parent = successor;
                }
                self.transplant(delete_node, successor);
                successor.left = delete_node.left;
                successor.left.?.parent = successor;
            }
        }

        pub fn init() Self {
            return Self{ .root = null };
        }
    };
}

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

test "repeated inserts should generate well-formed binary search tree" {
    const BTree = BinarySearchTree(u32);
    var tree = BTree.init();
    var node1 = try allocator.create(BTree.Node);
    node1.key = 5;
    node1.parent = null;
    node1.left = null;
    node1.right = null;
    var node2 = try allocator.create(BTree.Node);
    node2.key = 7;
    node2.parent = null;
    node2.left = null;
    node2.right = null;
    var node3 = try allocator.create(BTree.Node);
    node3.key = 3;
    node3.parent = null;
    node3.left = null;
    node3.right = null;
    var node4 = try allocator.create(BTree.Node);
    node4.key = 1;
    node4.parent = null;
    node4.left = null;
    node4.right = null;
    var node5 = try allocator.create(BTree.Node);
    node5.key = 2;
    node5.parent = null;
    node5.left = null;
    node5.right = null;

    tree.insert(node1);
    tree.insert(node2);
    tree.insert(node3);
    tree.insert(node4);
    tree.insert(node5);

    try std.testing.expectEqual(tree.root, node1);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node1.parent);
    try std.testing.expectEqual(node3, node1.left);
    try std.testing.expectEqual(node2, node1.right);
    try std.testing.expect(node1.key > node1.left.?.key);
    try std.testing.expect(node1.key <= node1.right.?.key);

    try std.testing.expectEqual(node1, node2.parent);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node2.left);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node2.right);

    try std.testing.expectEqual(node1, node3.parent);
    try std.testing.expectEqual(node4, node3.left);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node3.right);
    try std.testing.expect(node3.key > node3.left.?.key);

    try std.testing.expectEqual(node3, node4.parent);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node4.left);
    try std.testing.expectEqual(node5, node4.right);
    try std.testing.expect(node4.key <= node4.right.?.key);

    try std.testing.expectEqual(node4, node5.parent);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node5.left);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node5.right);
}

test "search should return correct node pointer" {
    const BTree = BinarySearchTree(i8);
    var tree = BTree.init();
    var node1 = try allocator.create(BTree.Node);
    node1.key = 5;
    node1.parent = null;
    node1.left = null;
    node1.right = null;
    var node2 = try allocator.create(BTree.Node);
    node2.key = -7;
    node2.parent = null;
    node2.left = null;
    node2.right = null;
    var node3 = try allocator.create(BTree.Node);
    node3.key = 3;
    node3.parent = null;
    node3.left = null;
    node3.right = null;
    var node4 = try allocator.create(BTree.Node);
    node4.key = -1;
    node4.parent = null;
    node4.left = null;
    node4.right = null;
    var node5 = try allocator.create(BTree.Node);
    node5.key = 2;
    node5.parent = null;
    node5.left = null;
    node5.right = null;

    tree.insert(node1);
    tree.insert(node2);
    tree.insert(node3);
    tree.insert(node4);
    tree.insert(node5);

    try std.testing.expectEqual(node1, tree.search(5));
    try std.testing.expectEqual(node2, tree.search(-7));
    try std.testing.expectEqual(node3, tree.search(3));
    try std.testing.expectEqual(node4, tree.search(-1));
    try std.testing.expectEqual(node5, tree.search(2));
    try std.testing.expectEqual(@as(?*BTree.Node, null), tree.search(100));
}

test "delete should remove a node from the tree while maintaining binary search tree property" {
    const BTree = BinarySearchTree(u64);
    var tree = BTree.init();
    var node1 = try allocator.create(BTree.Node);
    node1.key = 5;
    node1.parent = null;
    node1.left = null;
    node1.right = null;
    var node2 = try allocator.create(BTree.Node);
    node2.key = 7;
    node2.parent = null;
    node2.left = null;
    node2.right = null;
    var node3 = try allocator.create(BTree.Node);
    node3.key = 3;
    node3.parent = null;
    node3.left = null;
    node3.right = null;
    var node4 = try allocator.create(BTree.Node);
    node4.key = 1;
    node4.parent = null;
    node4.left = null;
    node4.right = null;
    var node5 = try allocator.create(BTree.Node);
    node5.key = 2;
    node5.parent = null;
    node5.left = null;
    node5.right = null;

    tree.insert(node1);
    tree.insert(node2);
    tree.insert(node3);
    tree.insert(node4);
    tree.insert(node5);

    tree.delete(node3);
    try std.testing.expectEqual(@as(?*BTree.Node, null), tree.search(3));

    try std.testing.expectEqual(tree.root, node1);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node1.parent);
    try std.testing.expectEqual(node4, node1.left);
    try std.testing.expectEqual(node2, node1.right);
    try std.testing.expect(node1.key > node1.left.?.key);
    try std.testing.expect(node1.key <= node1.right.?.key);

    try std.testing.expectEqual(node1, node2.parent);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node2.left);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node2.right);

    try std.testing.expectEqual(node1, node4.parent);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node4.left);
    try std.testing.expectEqual(node5, node4.right);
    try std.testing.expect(node4.key <= node4.right.?.key);

    try std.testing.expectEqual(node4, node5.parent);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node5.left);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node5.right);

    tree.delete(node1);
    try std.testing.expectEqual(@as(?*BTree.Node, null), tree.search(5));

    try std.testing.expectEqual(tree.root, node2);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node2.parent);
    try std.testing.expectEqual(node4, node2.left);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node2.right);
    try std.testing.expect(node2.key > node2.left.?.key);

    try std.testing.expectEqual(node2, node4.parent);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node4.left);
    try std.testing.expectEqual(node5, node4.right);
    try std.testing.expect(node4.key <= node4.right.?.key);

    try std.testing.expectEqual(node4, node5.parent);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node5.left);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node5.right);
}

test "should handle tricky deletion case where we transplant a distant node and also transplant its right child" {
    const BTree = BinarySearchTree(f32);
    var tree = BTree.init();
    var node1 = try allocator.create(BTree.Node);
    node1.key = 2; // root
    node1.parent = null;
    node1.left = null;
    node1.right = null;
    var node2 = try allocator.create(BTree.Node);
    node2.key = 1; // left
    node2.parent = null;
    node2.left = null;
    node2.right = null;
    var node3 = try allocator.create(BTree.Node);
    node3.key = 10; // right
    node3.parent = null;
    node3.left = null;
    node3.right = null;
    var node4 = try allocator.create(BTree.Node);
    node4.key = 9; // right left
    node4.parent = null;
    node4.left = null;
    node4.right = null;
    var node5 = try allocator.create(BTree.Node);
    node5.key = 8; // right left left
    node5.parent = null;
    node5.left = null;
    node5.right = null;
    var node6 = try allocator.create(BTree.Node);
    node6.key = 8.5; // right left left right
    node6.parent = null;
    node6.left = null;
    node6.right = null;

    tree.insert(node1);
    tree.insert(node2);
    tree.insert(node3);
    tree.insert(node4);
    tree.insert(node5);
    tree.insert(node6);

    tree.delete(node1);

    try std.testing.expectEqual(@as(?*BTree.Node, null), tree.search(2));

    try std.testing.expectEqual(node5, tree.root);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node5.parent);
    try std.testing.expectEqual(node2, node5.left);
    try std.testing.expectEqual(node3, node5.right);

    try std.testing.expectEqual(node5, node2.parent);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node2.left);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node2.right);

    try std.testing.expectEqual(node5, node3.parent);
    try std.testing.expectEqual(node4, node3.left);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node3.right);

    try std.testing.expectEqual(node3, node4.parent);
    try std.testing.expectEqual(node6, node4.left);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node4.right);

    try std.testing.expectEqual(node4, node6.parent);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node6.left);
    try std.testing.expectEqual(@as(?*BTree.Node, null), node6.right);
}
