const std = @import("std");

fn Matrix(comptime h: usize, comptime w: usize) type {
    return struct {
        data: [h][w]i32,
        pub const height = h;
        pub const width = w;

        const Self = @This();
        fn init(self: *Self) void {
            inline for (0..h) |i| {
                inline for (0..w) |j| {
                    self.data[i][j] = 0;
                }
            }
        }
    };
}

fn SquareMatrix(comptime size: usize) type {
    return Matrix(size, size);
}

fn init(comptime size: usize, matrix: *SquareMatrix(size)) void {
    for (0..size) |i| {
        for (0..size) |j| {
            matrix.data[i][j] = 0;
        }
    }
}

fn squareMatrixMultiply(comptime size: usize, left: *const SquareMatrix(size), right: *const SquareMatrix(size)) SquareMatrix(size) {
    var out = SquareMatrix(size){ .data = undefined };
    out.init();

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

fn isPowerOf2(n: usize) bool {
    if (n == 0) return false;
    if (n == 1) return true;
    if (n % 2 == 0) {
        return isPowerOf2(n / 2);
    }
    return false;
}

test "isPowerOf2 should work" {
    try std.testing.expect(isPowerOf2(1));
    try std.testing.expect(isPowerOf2(2));
    try std.testing.expect(isPowerOf2(4));
    try std.testing.expect(isPowerOf2(8));
    try std.testing.expect(isPowerOf2(256));
    try std.testing.expect(!isPowerOf2(0));
    try std.testing.expect(!isPowerOf2(3));
    try std.testing.expect(!isPowerOf2(15));
    try std.testing.expect(!isPowerOf2(17));
    try std.testing.expect(!isPowerOf2(1023));
}

const RecursiveSquareMatrixMultiplyError = error{
    NonPower2Dimensions,
};

fn recursiveSquareMatrixMultiply(comptime size: usize, left: *const SquareMatrix(size), right: *const SquareMatrix(size)) RecursiveSquareMatrixMultiplyError!SquareMatrix(size) {
    if (!isPowerOf2(size)) {
        return RecursiveSquareMatrixMultiplyError.NonPower2Dimensions;
    }
    var out = SquareMatrix(size){ .data = undefined };
    out.init();
    doRecursiveSquareMatrixMultiply(size, left, right, &out, 0, 0, 0, 0, 0, 0, size);
    return out;
}

fn doRecursiveSquareMatrixMultiply(
    comptime size: usize,
    left: *const SquareMatrix(size),
    right: *const SquareMatrix(size),
    out: *SquareMatrix(size),
    leftI: usize,
    leftJ: usize,
    rightI: usize,
    rightJ: usize,
    outI: usize,
    outJ: usize,
    subMatrixSize: usize,
) void {
    if (subMatrixSize == 1) {
        out.data[outI][outJ] += left.data[leftI][leftJ] * right.data[rightI][rightJ];
        return;
    }

    const shiftedLeftI = leftI + subMatrixSize / 2;
    const shiftedLeftJ = leftJ + subMatrixSize / 2;
    const shiftedRightI = rightI + subMatrixSize / 2;
    const shiftedRightJ = rightJ + subMatrixSize / 2;
    const shiftedOutI = outI + subMatrixSize / 2;
    const shiftedOutJ = outJ + subMatrixSize / 2;

    doRecursiveSquareMatrixMultiply(size, left, right, out, leftI, leftJ, rightI, rightJ, outI, outJ, subMatrixSize / 2);
    doRecursiveSquareMatrixMultiply(size, left, right, out, leftI, leftJ, rightI, shiftedRightJ, outI, shiftedOutJ, subMatrixSize / 2);
    doRecursiveSquareMatrixMultiply(size, left, right, out, shiftedLeftI, leftJ, rightI, rightJ, shiftedOutI, outJ, subMatrixSize / 2);
    doRecursiveSquareMatrixMultiply(size, left, right, out, shiftedLeftI, leftJ, rightI, shiftedRightJ, shiftedOutI, shiftedOutJ, subMatrixSize / 2);
    doRecursiveSquareMatrixMultiply(size, left, right, out, leftI, shiftedLeftJ, shiftedRightI, rightJ, outI, outJ, subMatrixSize / 2);
    doRecursiveSquareMatrixMultiply(size, left, right, out, leftI, shiftedLeftJ, shiftedRightI, shiftedRightJ, outI, shiftedOutJ, subMatrixSize / 2);
    doRecursiveSquareMatrixMultiply(size, left, right, out, shiftedLeftI, shiftedLeftJ, shiftedRightI, rightJ, shiftedOutI, outJ, subMatrixSize / 2);
    doRecursiveSquareMatrixMultiply(size, left, right, out, shiftedLeftI, shiftedLeftJ, shiftedRightI, shiftedRightJ, shiftedOutI, shiftedOutJ, subMatrixSize / 2);
}

test "recursiveSquareMatrixMultiply should return error if illegal dimensions" {
    const a = SquareMatrix(3){ .data = undefined };
    try std.testing.expectError(RecursiveSquareMatrixMultiplyError.NonPower2Dimensions, recursiveSquareMatrixMultiply(3, &a, &a));
}

test "recursiveSquareMatrixMultiply should work" {
    var id8 = SquareMatrix(8){ .data = undefined };
    var a = SquareMatrix(8){ .data = undefined };
    var b = SquareMatrix(8){ .data = undefined };
    for (0..8) |i| {
        for (0..8) |j| {
            if (i == j) {
                id8.data[i][j] = 1;
            } else {
                id8.data[i][j] = 0;
            }
            a.data[i][j] = @intCast(8 * i + j);
            b.data[i][j] = @intCast(64 + 8 * i + j);
        }
    }

    try std.testing.expectEqualDeep(a, try recursiveSquareMatrixMultiply(8, &id8, &a));
    try std.testing.expectEqualDeep(a, try recursiveSquareMatrixMultiply(8, &a, &id8));
    try std.testing.expectEqualDeep(b, try recursiveSquareMatrixMultiply(8, &id8, &b));
    try std.testing.expectEqualDeep(b, try recursiveSquareMatrixMultiply(8, &b, &id8));
    try std.testing.expectEqualDeep(squareMatrixMultiply(8, &a, &b), try recursiveSquareMatrixMultiply(8, &a, &b));
    try std.testing.expectEqualDeep(squareMatrixMultiply(8, &b, &a), try recursiveSquareMatrixMultiply(8, &b, &a));
}
