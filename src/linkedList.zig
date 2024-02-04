const std = @import("std");

pub fn Node(comptime T: type) type {
    return struct {
        prev: ?*Node(T),
        next: ?*Node(T),
        key: T,
    };
}

pub fn DoublyLinkedList(comptime T: type) type {
    return struct {
        head: ?*Node(T),
        allocator: std.mem.Allocator,

        const Self = @This();

        pub fn init(allocator: std.mem.Allocator) Self {
            return Self{ .head = null, .allocator = allocator };
        }

        pub fn deinit(self: *const Self) void {
            var next = self.head;
            while (next != null) {
                var newNext: ?*Node(T) = null;
                if (next) |nonOptionalNext| {
                    newNext = nonOptionalNext.next;
                    self.allocator.destroy(nonOptionalNext);
                }
                next = newNext;
            }
        }

        pub fn prepend(self: *Self, value: T) !*Node(T) {
            const node = try self.allocator.create(Node(T));
            node.key = value;
            node.prev = null;
            if (self.head) |oldHead| {
                oldHead.prev = node;
                node.next = oldHead;
            } else {
                node.next = null;
            }
            self.head = node;
            return node;
        }

        // since this only finds the first occurence of a value and is intended to be used with insert and delete, this list implementation doesn't work well for lists containing repeated values
        // should be fine for hash table, but might need rethinking if re-using in future
        pub fn search(self: Self, value: T) ?*Node(T) {
            var x = self.head;
            while (x != null and x.?.key != value) {
                x = x.?.next;
            }
            return x;
        }

        pub fn insert(self: *Self, newKey: T, oldNode: *Node(T)) !void {
            var newNode = try self.allocator.create(Node(T));
            newNode.key = newKey;
            newNode.prev = oldNode;
            newNode.next = oldNode.next;
            if (newNode.next) |newNodeNext| {
                newNodeNext.prev = newNode;
            }
            oldNode.next = newNode;
        }

        pub fn delete(self: *Self, oldNode: *Node(T)) void {
            defer {
                self.allocator.destroy(oldNode);
            }
            if (oldNode.next) |next| {
                next.prev = oldNode.prev;
            }
            if (oldNode.prev) |prev| {
                prev.next = oldNode.next;
            } else {
                self.head = oldNode.next;
            }
        }
    };
}

test "prepend should work" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) @panic("Memory leak");
    }

    var list = DoublyLinkedList(i32).init(allocator);
    defer {
        list.deinit();
    }

    const node1 = try list.prepend(1);
    const node2 = try list.prepend(2);
    const node3 = try list.prepend(3);

    try std.testing.expectEqual(node3, list.head.?);
    try std.testing.expectEqual(@as(?*Node(i32), null), node3.prev);
    try std.testing.expectEqual(node2, list.head.?.next.?);
    try std.testing.expectEqual(node1, list.head.?.next.?.next.?);
    try std.testing.expectEqual(@as(?*Node(i32), null), list.head.?.next.?.next.?.next);
}

test "search should work" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) @panic("Memory leak");
    }

    var list = DoublyLinkedList(i32).init(allocator);
    defer {
        list.deinit();
    }

    _ = try list.prepend(1);
    _ = try list.prepend(2);
    _ = try list.prepend(3);
    _ = try list.prepend(2);

    try std.testing.expectEqual(list.head, list.search(2));
    try std.testing.expectEqual(list.head.?.next, list.search(3));
    try std.testing.expectEqual(list.head.?.next.?.next.?.next, list.search(1));
    try std.testing.expectEqual(@as(?*Node(i32), null), list.search(0));
}

test "insert should work" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) @panic("Memory leak");
    }

    var list = DoublyLinkedList(i32).init(allocator);
    defer {
        list.deinit();
    }

    const node1 = try list.prepend(1);
    const node2 = try list.prepend(2);
    const node3 = try list.prepend(3);

    try list.insert(4, node1);
    try list.insert(5, node2);
    try list.insert(6, node3);

    try std.testing.expectEqual(@as(i32, 3), list.head.?.key);
    try std.testing.expectEqual(@as(i32, 6), list.head.?.next.?.key);
    try std.testing.expectEqual(@as(i32, 2), list.head.?.next.?.next.?.key);
    try std.testing.expectEqual(@as(i32, 5), list.head.?.next.?.next.?.next.?.key);
    try std.testing.expectEqual(@as(i32, 1), list.head.?.next.?.next.?.next.?.next.?.key);
    try std.testing.expectEqual(@as(i32, 4), list.head.?.next.?.next.?.next.?.next.?.next.?.key);
    try std.testing.expectEqual(@as(?*Node(i32), null), list.head.?.next.?.next.?.next.?.next.?.next.?.next);
}

test "delete should work" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) @panic("Memory leak");
    }

    var list = DoublyLinkedList(i32).init(allocator);
    defer {
        list.deinit();
    }

    const node1 = try list.prepend(1);
    const node2 = try list.prepend(2);
    const node3 = try list.prepend(3);
    const node4 = try list.prepend(4);
    const node5 = try list.prepend(5);

    list.delete(node5);
    list.delete(node3);
    list.delete(node1);

    try std.testing.expectEqual(node4, list.head.?);
    try std.testing.expectEqual(@as(?*Node(i32), null), node4.prev);
    try std.testing.expectEqual(node2, list.head.?.next.?);
    try std.testing.expectEqual(@as(?*Node(i32), null), list.head.?.next.?.next);
}
