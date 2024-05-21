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

        pub fn insert(self: *Self, new_value: K) !void {
            var x_index = self.root;
            var y_index: ?NodeIndex = null;
            while (x_index) |x| {
                y_index = x;
                if (new_value < self.node_keys.items[x]) {
                    x_index = self.node_lefts.items[x];
                } else {
                    x_index = self.node_rights.items[x];
                }
            }

            const new_node_index: NodeIndex = self.node_keys.items.len;
            try self.node_keys.append(new_value);
            try self.node_lefts.append(null);
            try self.node_rights.append(null);
            try self.node_parents.append(y_index);
            if (y_index) |y| {
                if (new_value < self.node_keys.items[y]) {
                    self.node_lefts.items[y] = new_node_index;
                } else {
                    self.node_rights.items[y] = new_node_index;
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
