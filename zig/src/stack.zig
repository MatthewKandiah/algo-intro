const std = @import("std");

const StackError = error{
    Overflow,
    Underflow,
};

fn Stack(comptime T: type, comptime sz: usize) type {
    return struct {
        data: []T,
        head: usize = 0,

        const Self = @This();
        fn init(allocator: std.mem.Allocator) !Self {
            return Self{
                .data = try allocator.alloc(T, sz),
            };
        }

        fn deinit(self: Self, allocator: std.mem.Allocator) void {
            allocator.free(self.data);
        }

        fn isEmpty(self: Self) bool {
            return self.head == 0;
        }

        fn push(self: *Self, val: T) StackError!void {
            if (self.head == self.data.len) return StackError.Overflow;
            self.data[self.head] = val;
            self.head += 1;
        }

        fn pop(self: *Self) StackError!T {
            if (self.head == 0) return StackError.Underflow;
            self.head -= 1;
            return self.data[self.head];
        }
    };
}

test "should make an empty stack of any size and type" {
    const types = [_]type{ i32, u16, c_char, f64, [*]u8, *[]const u8 };
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    inline for (0..100) |i| {
        const t = types[i % types.len];
        const x = try Stack(t, i).init(allocator);
        try std.testing.expectEqual(i, x.data.len);
        try std.testing.expectEqual(@as(usize, 0), x.head);
        try std.testing.expect(x.isEmpty());
        x.deinit(allocator);
    }
}

test "should push and pop integer values" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var x = try Stack(i32, 10).init(allocator);

    try x.push(1);
    try x.push(2);
    try x.push(3);
    try std.testing.expectEqual(@as(usize, 3), x.head);
    try std.testing.expectEqual(@as(i32, 3), try x.pop());
    try std.testing.expectEqual(@as(usize, 2), x.head);
    try std.testing.expectEqual(@as(i32, 2), try x.pop());
    try std.testing.expectEqual(@as(usize, 1), x.head);
    try std.testing.expectEqual(@as(i32, 1), try x.pop());
    try std.testing.expectEqual(@as(usize, 0), x.head);
}

test "should push and pop string values" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var x = try Stack([]const u8, 10).init(allocator);

    try x.push("World!");
    try x.push(", ");
    try x.push("Hello");

    try std.testing.expectEqualStrings("Hello", try x.pop());
    try std.testing.expectEqualStrings(", ", try x.pop());
    try std.testing.expectEqualStrings("World!", try x.pop());
}

test "should error if you push too many values" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var x = try Stack(i8, 2).init(allocator);

    x.push(1) catch unreachable;
    x.push(2) catch unreachable;
    x.push(3) catch |e| {
        try std.testing.expectEqual(StackError.Overflow, e);
    };
}

test "should error if you pop too many values" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var x = try Stack(f32, 50).init(allocator);

    try x.push(1.0);
    try x.push(2.0);

    _ = x.pop() catch unreachable;
    _ = x.pop() catch unreachable;
    _ = x.pop() catch |e| {
        try std.testing.expectEqual(StackError.Underflow, e);
    };
}
