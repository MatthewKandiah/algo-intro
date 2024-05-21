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

        pub fn verifyNodes(self: *const Self) bool {
            const number_of_nodes = self.node_keys.items.len;
            if (number_of_nodes != 0 and self.root == null) {
                return false;
            }
            if (self.node_parents.items.len != number_of_nodes or self.node_lefts.items.len != number_of_nodes or self.node_rights.items.len != number_of_nodes) {
                return false;
            }

            var node_without_parent = null;
            for (self.node_parents, 0..) |parent, i| {
                if (parent != null) {
                    continue;
                }
                if (node_without_parent != null) {
                    return false;
                }
                node_without_parent = i;
            }
            if (node_without_parent != self.root) {
                return false;
            }

            // TODO: verify lefts and rights appear at most once, and parents appear at most twice

            return true;
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
