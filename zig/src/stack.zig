const std = @import("std");

fn stack(comptime T: type, comptime size: usize) type {
    return struct {
        const Self = @This();
        data: [size]T,
        head: usize,

        fn init() Self {
            return Self {
                .data = undefined,
                .head = 0,
            };
        }
    };
} 

test "should make an empty stack of any size and type" {
    const types = [_]type{i32, u16, c_char, f64};
    inline for (0..100) |i| {
        const t = types[i % types.len];
        const x = stack(t, i).init();
        try std.testing.expect(x.data.len == i);
        try std.testing.expect(x.head == 0);
    }
}

