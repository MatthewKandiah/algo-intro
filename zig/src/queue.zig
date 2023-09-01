const std = @import("std");

const QueueError = error {
    Overflow,
    Underflow,
};

fn Queue(comptime T: type, comptime sz: usize) type {
    return struct {
        data: []T,
        head: usize = 0,
        tail: usize = 0,

        const Self = @This();

        fn init(allocator: std.mem.Allocator) !Self {
            return Self{
                .data = try allocator.alloc(T, sz),
            };
        }

        fn deinit(self: Self, allocator: std.mem.Allocator) !void {
            try allocator.free(self.data);
        }

        fn enqueue(self: *Self, val: T) QueueError!void {
            self.data[self.head] = val;
            self.head += 1;
            self.head %= sz;
        }

        fn dequeue(self: *Self) QueueError!T {
            const val = self.data[self.tail];
            self.tail += 1;
            self.tail %= sz;
            return val;
        }
    };
}

test "should enqueue and dequeue values" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var x = try Queue(i32, 5).init(allocator);

    try x.enqueue(1);
    try x.enqueue(2);
    try x.enqueue(3);
    try x.enqueue(4);
    try x.enqueue(5);

    try std.testing.expectEqual(@as(i32, 1), try x.dequeue());
    try std.testing.expectEqual(@as(i32, 2), try x.dequeue());
    try std.testing.expectEqual(@as(i32, 3), try x.dequeue());
    try std.testing.expectEqual(@as(i32, 4), try x.dequeue());
    try std.testing.expectEqual(@as(i32, 5), try x.dequeue());

    try x.enqueue(1);
    try x.enqueue(2);
    try x.enqueue(3);

    try std.testing.expectEqual(@as(i32, 1), try x.dequeue());
    try std.testing.expectEqual(@as(i32, 2), try x.dequeue());

    try x.enqueue(4);
    try x.enqueue(5);
    try x.enqueue(6);
    try x.enqueue(7);

    try std.testing.expectEqual(@as(i32, 3), try x.dequeue());
    try std.testing.expectEqual(@as(i32, 4), try x.dequeue());
    try std.testing.expectEqual(@as(i32, 5), try x.dequeue());
    try std.testing.expectEqual(@as(i32, 6), try x.dequeue());
    try std.testing.expectEqual(@as(i32, 7), try x.dequeue());
}
