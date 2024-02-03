const std = @import("std");

fn Node(comptime T: type) type {
    return struct {
        prev: ?*Node(T),
        next: ?*Node(T),
        key: T,
    };
}

fn DoublyLinkedList(comptime T: type) type {
    return struct {
        head: ?*Node(T),
        allocator: std.mem.Allocator,

        const Self = @This();

        fn init(allocator: std.mem.Allocator) Self {
            return Self{ .head = null, .allocator = allocator };
        }

        fn deinit(self: *Self) void {
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

        fn prepend(self: *Self, value: T) !void {
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
        }

        fn search(self: Self, value: T) ?*Node(T) {
            var x = self.head;
            while (x != null and x.?.key != value) {
                x = x.?.next;
            }
            return x;
        }
    };
}

test "it should be possible to prepend items to list" {
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

    try list.prepend(1);
    try list.prepend(2);
    try list.prepend(3);

    try std.testing.expectEqual(@as(i32, 3), list.head.?.key);
    try std.testing.expectEqual(@as(i32, 2), list.head.?.next.?.key);
    try std.testing.expectEqual(@as(i32, 1), list.head.?.next.?.next.?.key);
}

test "it should be possible to search a list for an item" {
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
    
    try list.prepend(1);
    try list.prepend(2);
    try list.prepend(3);
    try list.prepend(2);

    try std.testing.expectEqual(list.head, list.search(2));
    try std.testing.expectEqual(list.head.?.next, list.search(3));
    try std.testing.expectEqual(list.head.?.next.?.next.?.next, list.search(1));
    try std.testing.expectEqual(@as(?*Node(i32), null), list.search(0));
}
