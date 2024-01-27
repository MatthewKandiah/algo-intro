const std = @import("std");
const util = @import("util.zig");

fn partition(numbers: []i32, headIdx: usize, tailIdx: usize) usize {
    // set pivot to last element in list
    const pivotVal = numbers[tailIdx];
    // where the pivot will eventually be inserted
    var pivotIdx = headIdx;

    for (headIdx..tailIdx) |i| {
        // if number belongs on the low side
        if (numbers[i] <= pivotVal) {
            // increment size of low side
            pivotIdx += 1;
            // swap the number that was one past the end of the low side with our number that should be on the low side
            // if there are numbers on the high side, this means swapping a number on the high side to somewhere else on the high side
            // if there are no numbers on the high side yet, then the incremented lowSideTailIdx is equal to i, and this step is a no-op
            const tmp: i32 = numbers[pivotIdx - 1];
            numbers[pivotIdx - 1] = numbers[i];
            numbers[i] = tmp;
        }
    }
    // swap the pivot value from the end of the array to just after the low side
    // the value it's swapped with belongs on the high side, so this doesn't wreck the sorted order
    const tmp: i32 = numbers[pivotIdx];
    numbers[pivotIdx] = numbers[tailIdx];
    numbers[tailIdx] = tmp;

    return pivotIdx;
}

fn quickSortRange(numbers: []i32, subarrayHeadIdx: usize, subarrayTailIdx: usize) void {
    const pivotIndex: usize = partition(numbers, subarrayHeadIdx, subarrayTailIdx);
    if (pivotIndex > subarrayHeadIdx) {
        quickSortRange(numbers, subarrayHeadIdx, pivotIndex - 1);
    }
    if (pivotIndex < subarrayTailIdx) {
        quickSortRange(numbers, pivotIndex + 1, subarrayTailIdx);
    }
}

pub fn quickSort(numbers: []i32) void {
    if (numbers.len >= 2) {
        quickSortRange(numbers, 0, numbers.len - 1);
    }
}

test "quick sort - trivial case" {
    var numbers = [_]i32{ 1, 2, 3, 4 };
    quickSort(&numbers);
    const expectedNumbers = [_]i32{ 1, 2, 3, 4 };
    try std.testing.expect(std.mem.eql(i32, &numbers, &expectedNumbers));
}

test "quick sort - reverse case" {
    var numbers = [_]i32{ 4, 3, 2, 1 };
    quickSort(&numbers);
    const expectedNumbers = [_]i32{ 1, 2, 3, 4 };
    try std.testing.expect(std.mem.eql(i32, &numbers, &expectedNumbers));
}

test "quick sort - empty case" {
    var numbers = [_]i32{};
    quickSort(&numbers);
    const expectedNumbers = [_]i32{};
    try std.testing.expect(std.mem.eql(i32, &numbers, &expectedNumbers));
}

test "quick sort - single entry case" {
    var numbers = [_]i32{5};
    quickSort(&numbers);
    const expectedNumbers = [_]i32{5};
    try std.testing.expect(std.mem.eql(i32, &numbers, &expectedNumbers));
}

test "quick sort - random numbers" {
    const DEBUG = false;
    const RUN_NUMBER = 100;

    for (0..RUN_NUMBER) |_| {
        var numbers: [100]i32 = undefined;
        util.randomiseIntegers(&numbers, 100);
        if (DEBUG) {
            std.debug.print("Before sorting: ", .{});
            util.printNumbers(&numbers);
        }

        quickSort(&numbers);
        if (DEBUG) {
            std.debug.print("After sorting: ", .{});
            util.printNumbers(&numbers);
        }

        for (1..numbers.len) |idx| {
            try std.testing.expect(numbers[idx] >= numbers[idx - 1]);
        }
    }
}
