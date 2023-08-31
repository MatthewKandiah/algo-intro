const std = @import("std");

fn stack(comptime T: type,  comptime sz: usize) type {
    return struct {
        data: []T,
        head: usize = 0,

        const Self = @This();
        fn init(allocator: std.mem.Allocator) !Self {
            return Self {
                .data = try allocator.alloc(T, sz),
            };
        }

        fn deinit(self: Self, allocator: std.mem.Allocator) void {
            allocator.free(self.data);
        }
    };
}

test "should make an empty stack of any size and type" {
    const types = [_]type{i32, u16, c_char, f64, [*] u8, *[] const u8};
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    inline for (0..100) |i| {
        const t = types[i % types.len];
        const x = try stack(t, i).init(allocator);
        try std.testing.expect(x.data.len == i);
        try std.testing.expect(x.head == 0);
        x.deinit(allocator);
    }
}

