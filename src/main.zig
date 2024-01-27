const std = @import("std");

pub fn main() void {
    std.debug.print("Coming soon!", .{});
}

fn bubble_sort(comptime size: usize, comptime T: type, list: *[size]T) void {
    var i: usize = 0;
    while (i < list.len) {
        var j: usize = 0;
        while (j < list.len - 1 - i) {
            const left = list[j];
            const right = list[j + 1];
            if (left > right) {
                list[j] = right;
                list[j + 1] = left;
            }
            j += 1;
        }
        i += 1;
    }
}

test "bubble sort should work" {
    var list_i32 = [_]i32{ 5, 3, 2, 4, 1 };
    var expectedResult_i32 = [_]i32{ 1, 2, 3, 4, 5 };
    bubble_sort(list_i32.len, i32, &list_i32);
    try std.testing.expectEqualSlices(i32, &expectedResult_i32, &list_i32);

    var list_u8 = [_]u8{ 5, 3, 2, 4, 1 };
    var expectedResult_u8 = [_]u8{ 1, 2, 3, 4, 5 };
    bubble_sort(list_u8.len, u8, &list_u8);
    try std.testing.expectEqualSlices(u8, &expectedResult_u8, &list_u8);
}
