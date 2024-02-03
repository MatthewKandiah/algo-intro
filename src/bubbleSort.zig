const std = @import("std");
const sortingUtils = @import("./sortUtils.zig");
const isSorted = sortingUtils.isSorted;

fn bubbleSort(comptime size: usize, comptime T: type, list: *[size]T) void {
    for (0..list.len) |i| {
        for (0..list.len - 1 - i) |j| {
            const left = list[j];
            const right = list[j + 1];
            if (left > right) {
                list[j] = right;
                list[j + 1] = left;
            }
        }
    }
}

test "bubble sort should work" {
    var list_i32 = [_]i32{ 5, 3, 2, 4, 1 };
    bubbleSort(list_i32.len, i32, &list_i32);
    try std.testing.expect(isSorted(list_i32.len, i32, &list_i32));

    var list_u8 = [_]u8{ 5, 3, 2, 4, 1 };
    bubbleSort(list_u8.len, u8, &list_u8);
    try std.testing.expect(isSorted(list_u8.len, u8, &list_u8));
}
