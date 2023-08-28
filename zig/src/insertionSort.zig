const std = @import("std");
const util = @import("util.zig");

fn insertionSort(numbers: []i32) void {
    var valIdx: usize = 1;
    while (valIdx < numbers.len) : (valIdx += 1) {
        const val: i32 = numbers[valIdx];
        var compIdx: usize = valIdx;
        while (compIdx > 0 and numbers[compIdx - 1] > val) : (compIdx -= 1) {
                numbers[compIdx] = numbers[compIdx - 1];
        }
        if (compIdx != valIdx) {
            numbers[compIdx] = val;
        }
    }
}

test "insertion sort - trivial case" {
    var numbers = [_]i32{ 1, 2, 3, 4 };
    insertionSort(&numbers);
    const expectedNumbers = [_]i32{ 1, 2, 3, 4 };
    try std.testing.expect(std.mem.eql(i32, &numbers, &expectedNumbers));
}

test "insertion sort - reverse case" {
    var numbers = [_]i32{ 4, 3, 2, 1 };
    insertionSort(&numbers);
    const expectedNumbers = [_]i32{ 1, 2, 3, 4 };
    try std.testing.expect(std.mem.eql(i32, &numbers, &expectedNumbers));
}

test "insertion sort - empty case" {
    var numbers = [_]i32{};
    insertionSort(&numbers);
    const expectedNumbers = [_]i32{};
    try std.testing.expect(std.mem.eql(i32, &numbers, &expectedNumbers));
}

test "insertion sort - single entry case" {
    var numbers = [_]i32{5};
    insertionSort(&numbers);
    const expectedNumbers = [_]i32{5};
    try std.testing.expect(std.mem.eql(i32, &numbers, &expectedNumbers));
}

test "insertion sort - random numbers" {
    const DEBUG = false;
    const RUN_NUMBER = 100;

    for (0..RUN_NUMBER) |_| {
        var numbers: [100]i32 = undefined;
        util.randomiseIntegers(&numbers, 100);
        if (DEBUG) {
            std.debug.print("Before sorting: ", .{});
            util.printNumbers(&numbers);
        }

        insertionSort(&numbers);
        if (DEBUG) {
            std.debug.print("After sorting: ", .{});
            util.printNumbers(&numbers);
        }

        for (1..numbers.len) |idx| {
            try std.testing.expect(numbers[idx] >= numbers[idx - 1]);
        }
    }
}
