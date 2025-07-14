const std = @import("std");
const sortingUtils = @import("./sortUtils.zig");
const isSorted = sortingUtils.isSorted;

fn insertionSort(comptime size: usize, comptime T: type, list: *[size]T) void {
    for (1..list.len) |i| {
        const value = list[i];
        var j: usize = 0;
        while (j < i) {
            if (list[i - 1 - j] > value) {
                list[i - j] = list[i - 1 - j];
                j += 1;
            } else {
                break;
            }
        }
        list[i - j] = value;
    }
}

test "insertion_sort should work" {
    var list_i32 = [_]i32{ 5, 3, 2, 4, 1 };
    insertionSort(list_i32.len, i32, &list_i32);
    try std.testing.expect(isSorted(list_i32.len, i32, &list_i32));

    var list_u8 = [_]u8{ 5, 3, 2, 4, 1 };
    insertionSort(list_u8.len, u8, &list_u8);
    try std.testing.expect(isSorted(list_u8.len, u8, &list_u8));
}
