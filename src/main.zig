const std = @import("std");

pub fn main() void {
    std.debug.print("Coming soon!", .{});
}

fn isSorted(comptime size: usize, comptime T: type, list: *const [size]T) bool {
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

fn Matrix(comptime h: usize, comptime w: usize) type {
    return struct {
        data: [h][w]i32,
        pub const height = h;
        pub const width = w;
    };
}

fn SquareMatrix(comptime size: usize) type {
    return Matrix(size, size);
}

fn squareMatrixMultiply(comptime size: usize, left: *const SquareMatrix(size), right: *const SquareMatrix(size)) SquareMatrix(size) {
    var out = SquareMatrix(size){ .data = undefined };
    for (0..size) |i| {
        for (0..size) |j| {
            out.data[i][j] = 0;
        }
    }

    for (0..size) |i| {
        for (0..size) |j| {
            for (0..size) |k| {
                out.data[i][j] += left.data[i][k] * right.data[k][j];
            }
        }
    }
    return out;
}

test "squareMatrixMultiply should work" {
    const id2 = SquareMatrix(2){ .data = [2][2]i32{ [2]i32{ 1, 0 }, [2]i32{ 0, 1 } } };
    const a = SquareMatrix(2){ .data = [2][2]i32{ [2]i32{ 1, 2 }, [2]i32{ 3, 4 } } };
    const b = SquareMatrix(2){ .data = [2][2]i32{ [2]i32{ 5, 6 }, [2]i32{ 7, 8 } } };

    try std.testing.expectEqualDeep(a, squareMatrixMultiply(2, &id2, &a));
    try std.testing.expectEqualDeep(a, squareMatrixMultiply(2, &a, &id2));
    try std.testing.expectEqualDeep(b, squareMatrixMultiply(2, &id2, &b));
    try std.testing.expectEqualDeep(b, squareMatrixMultiply(2, &b, &id2));

    const ab = SquareMatrix(2){ .data = [2][2]i32{ [2]i32{ 19, 22 }, [2]i32{ 43, 50 } } };
    const ba = SquareMatrix(2){ .data = [2][2]i32{ [2]i32{ 23, 34 }, [2]i32{ 31, 46 } } };
    try std.testing.expectEqualDeep(ab, squareMatrixMultiply(2, &a, &b));
    try std.testing.expectEqualDeep(ba, squareMatrixMultiply(2, &b, &a));

    const id3 = SquareMatrix(3){ .data = [3][3]i32{ [3]i32{ 1, 0, 0 }, [3]i32{ 0, 1, 0 }, [3]i32{ 0, 0, 1 } } };
    const c = SquareMatrix(3){ .data = [3][3]i32{ [3]i32{ 1, 2, 3 }, [3]i32{ 4, 5, 6 }, [3]i32{ 7, 8, 9 } } };
    try std.testing.expectEqualDeep(c, squareMatrixMultiply(3, &id3, &c));
    try std.testing.expectEqualDeep(c, squareMatrixMultiply(3, &c, &id3));
}
