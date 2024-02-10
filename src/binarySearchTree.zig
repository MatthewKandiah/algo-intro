const std = @import("std");

fn Node(comptime T: type) type {
    return struct {
        prev: ?*Node(T),
        left: ?*Node(T),
        right: ?*Node(T),
        value: T,
    };
}

fn BinarySearchTree(comptime T: type) type {
    return struct {
        root: ?*Node(T),
        allocator: std.mem.Allocator,

        const Self = @This();

        fn init(allocator: std.mem.Allocator) Self {
            return Self {
                .root = null,
                .allocator = allocator,
            };
        }

        fn deinit(self: *Self) void {
            if (self.root) |root| {
                // you could choose to deinitialise part of a sub tree and cause use-after-free bugs
                // could add protection against that by checking if the root node has a non-null previous and disconnecting the sub tree / just not allowing you to deinit in that case
                // not going to bother for now, something to reconsider if this causes pain later!
                self.leftSubTree().deinit();
                self.rightSubTree().deinit();
                self.allocator.destroy(root);
            }
        }

        fn leftSubTree(self: *const Self) Self {
            // new tree's root has non-null previous
            return Self {.root = self.left, .allocator = self.allocator};
        }

        fn rightSubTree(self: *const Self) Self {
            // new tree's root has non-null previous
            return Self {.root = self.right, .allocator = self.allocator};
        }
    };
}

