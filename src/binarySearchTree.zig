const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn BinarySearchTree(comptime K: type) type {
    const NodeIndex: type = usize;
    return struct {
        root: ?NodeIndex,
        node_keys: std.ArrayListAligned(K, null),
        node_lefts: std.ArrayListAligned(?NodeIndex, null),
        node_rights: std.ArrayListAligned(?NodeIndex, null),
        node_parents: std.ArrayListAligned(?NodeIndex, null),

        const Self = @This();

        pub fn init(allocator: Allocator) Self {
            return Self{
                .root = null,
                .node_keys = std.ArrayList(K).init(allocator),
                .node_lefts = std.ArrayList(?NodeIndex).init(allocator),
                .node_rights = std.ArrayList(?NodeIndex).init(allocator),
                .node_parents = std.ArrayList(?NodeIndex).init(allocator),
            };
        }

        pub fn deinit(self: *const Self) void {
            self.node_keys.deinit();
            self.node_lefts.deinit();
            self.node_rights.deinit();
            self.node_parents.deinit();
        }

        fn add_new_node(
            self: *Self,
            key: K,
            left_index: ?NodeIndex,
            right_index: ?NodeIndex,
            parent_index: ?NodeIndex,
        ) !void {
            try self.node_keys.append(key);
            try self.node_lefts.append(left_index);
            try self.node_rights.append(right_index);
            try self.node_parents.append(parent_index);
        }

        pub fn insert(self: *Self, new_value: K) !void {
            var compare_index = self.root;
            var parent_index: ?NodeIndex = null;
            while (compare_index) |idx| {
                parent_index = idx;
                if (new_value < self.node_keys.items[idx]) {
                    compare_index = self.node_lefts.items[idx];
                } else {
                    compare_index = self.node_rights.items[idx];
                }
            }

            const new_node_index: NodeIndex = self.node_keys.items.len;
            try self.add_new_node(new_value, null, null, parent_index);
            if (parent_index) |idx| {
                if (new_value < self.node_keys.items[idx]) {
                    self.node_lefts.items[idx] = new_node_index;
                } else {
                    self.node_rights.items[idx] = new_node_index;
                }
            } else {
                self.root = new_node_index;
            }
        }
    };
}

test "should init and deinit without memory leaking" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const check = gpa.deinit();
        if (check == .leak) {
            @panic("Memory leak");
        }
    }
    var tree = BinarySearchTree(u32).init(gpa.allocator());

    tree.root = 0;
    try tree.node_keys.append(1);
    try tree.node_lefts.append(null);
    try tree.node_rights.append(2);
    try tree.node_parents.append(null);

    try tree.node_keys.append(3);
    try tree.node_lefts.append(null);
    try tree.node_rights.append(null);
    try tree.node_parents.append(0);

    tree.deinit();
}

test "should insert new nodes in the binary search tree" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const check = gpa.deinit();
        if (check == .leak) {
            @panic("Memory leak");
        }
    }

    var tree = BinarySearchTree(i32).init(gpa.allocator());
    defer tree.deinit();

    try tree.insert(5);
    try std.testing.expectEqual(0, tree.root);
    try std.testing.expectEqualSlices(i32, &.{5}, tree.node_keys.items);
    try std.testing.expectEqualSlices(?usize, &.{null}, tree.node_lefts.items);
    try std.testing.expectEqualSlices(?usize, &.{null}, tree.node_rights.items);
    try std.testing.expectEqualSlices(?usize, &.{null}, tree.node_parents.items);

    try tree.insert(3);
    try std.testing.expectEqual(0, tree.root);
    try std.testing.expectEqualSlices(i32, &.{ 5, 3 }, tree.node_keys.items);
    try std.testing.expectEqualSlices(?usize, &.{ 1, null }, tree.node_lefts.items);
    try std.testing.expectEqualSlices(?usize, &.{ null, null }, tree.node_rights.items);
    try std.testing.expectEqualSlices(?usize, &.{ null, 0 }, tree.node_parents.items);

    try tree.insert(7);
    try std.testing.expectEqual(0, tree.root);
    try std.testing.expectEqualSlices(i32, &.{ 5, 3, 7 }, tree.node_keys.items);
    try std.testing.expectEqualSlices(?usize, &.{ 1, null, null }, tree.node_lefts.items);
    try std.testing.expectEqualSlices(?usize, &.{ 2, null, null }, tree.node_rights.items);
    try std.testing.expectEqualSlices(?usize, &.{ null, 0, 0 }, tree.node_parents.items);

    try tree.insert(4);
    try tree.insert(2);
    try tree.insert(5);
    try tree.insert(9);
    try std.testing.expectEqual(0, tree.root);
    try std.testing.expectEqualSlices(i32, &.{ 5, 3, 7, 4, 2, 5, 9 }, tree.node_keys.items);
    try std.testing.expectEqualSlices(?usize, &.{ 1, 4, 5, null, null, null, null }, tree.node_lefts.items);
    try std.testing.expectEqualSlices(?usize, &.{ 2, 3, 6, null, null, null, null }, tree.node_rights.items);
    try std.testing.expectEqualSlices(?usize, &.{ null, 0, 0, 1, 1, 2, 2 }, tree.node_parents.items);
}
