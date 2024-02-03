const std = @import("std");

pub fn isSorted(comptime size: usize, comptime T: type, list: *const [size]T) bool {
    for (0..list.len - 1) |i| {
        if (list[i] > list[i + 1]) {
            return false;
        }
    }
    return true;
}

test "isSorted should work" {
    const sortedList = [_]i32{ 1, 2, 3, 4, 5 };
    const unsortedList = [_]i32{ 1, 2, 3, 5, 4 };

    try std.testing.expectEqual(isSorted(sortedList.len, i32, &sortedList), true);
    try std.testing.expectEqual(isSorted(unsortedList.len, i32, &unsortedList), false);
}
