const std = @import("std");

const QueueError = error{
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

        fn deinit(self: *Self, allocator: std.mem.Allocator) void {
            allocator.free(self.data);
        }

        fn isFull(self: Self) bool {
            return self.head - self.tail >= sz;
        }

        fn enqueue(self: *Self, val: T) QueueError!void {
            if (self.isFull()) return QueueError.Overflow;
            self.data[self.head % sz] = val;
            self.head += 1;
        }

        fn dequeue(self: *Self) QueueError!T {
            if (self.tail == self.head) return QueueError.Underflow;
            const val = self.data[self.tail % sz];
            self.tail += 1;
            return val;
        }
    };
}

test "should return if full" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var x = try Queue(i32, 3).init(allocator);
    try std.testing.expect(!x.isFull());

    try x.enqueue(1);
    try std.testing.expect(!x.isFull());

    try x.enqueue(2);
    try std.testing.expect(!x.isFull());

    try x.enqueue(3);
    try std.testing.expect(x.isFull());

    _ = try x.dequeue();
    try std.testing.expect(!x.isFull());

    try x.enqueue(4);
    try std.testing.expect(x.isFull());
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

    x.deinit(allocator);
}

test "should return overflow error" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var x = try Queue(i32, 2).init(allocator);

    try x.enqueue(1);
    try x.enqueue(2);
    x.enqueue(3) catch |e| try std.testing.expectEqual(QueueError.Overflow, e);
    x.deinit(allocator);
}

test "should return underflow error" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var x = try Queue(i32, 2).init(allocator);

    _ = x.dequeue() catch |e| try std.testing.expectEqual(QueueError.Underflow, e);

    try x.enqueue(1);
    _ = try x.dequeue();
    _ = x.dequeue() catch |e| try std.testing.expectEqual(QueueError.Underflow, e);
    x.deinit(allocator);
}
