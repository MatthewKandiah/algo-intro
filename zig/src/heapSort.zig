const std = @import("std");
const util = @import("util.zig");

fn parent(i: usize) usize {
    return ((i + 1) / 2) - 1;
}

fn leftChild(i: usize) usize {
    return 2 * i + 1;
}

fn rightChild(i: usize) usize {
    return 2 * (i + 1);
}

// assume that left and right children already satisfy max heap property
// but that numbers[idx] may be smaller than its left and/or right child
// transform numbers into a max heap
fn maxHeapify(numbers: []i32, idx: usize) void {
    const lIdx: usize = leftChild(idx);
    const rIdx: usize = rightChild(idx);
    var largestIdx: usize = undefined;

    if (lIdx < numbers.len and numbers[lIdx] > numbers[idx]) {
        largestIdx = lIdx;
    } else {
        largestIdx = idx;
    }

    if (rIdx < numbers.len and numbers[rIdx] > numbers[largestIdx]) {
        largestIdx = rIdx;
    }

    if (largestIdx != idx) {
        const tmp: i32 = numbers[idx];
        numbers[idx] = numbers[largestIdx];
        numbers[largestIdx] = tmp;
        maxHeapify(numbers, largestIdx);
    }
}

fn buildMaxHeap(numbers: []i32) void {
    const minIdxWithoutChild: usize = numbers.len / 2;
    for (0..minIdxWithoutChild) |i| {
        maxHeapify(numbers, minIdxWithoutChild - 1 - i);
    }
}

pub fn heapSort(numbers: []i32) void {
    buildMaxHeap(numbers);

    var heapSize = numbers.len;
    while (heapSize > 1) : (heapSize -= 1) {
        const tmp: i32 = numbers[0];
        numbers[0] = numbers[heapSize - 1];
        numbers[heapSize - 1] = tmp;
        maxHeapify(numbers[0 .. heapSize - 1], 0);
    }
}

test "build max heap - trivial case" {
    var numbers = [_]i32{ 4, 3, 0, 2, 1 };
    buildMaxHeap(&numbers);
    var expectedNumbers = [_]i32{ 4, 3, 0, 2, 1 };
    try std.testing.expect(std.mem.eql(i32, &numbers, &expectedNumbers));
}

test "build max heap - reverse case" {
    var numbers = [_]i32{ 0, 1, 2, 3, 4 };
    buildMaxHeap(&numbers);
    for (numbers, 0..) |number, idx| {
        if (leftChild(idx) < numbers.len) {
            try std.testing.expect(number > numbers[leftChild(idx)]);
        }
        if (rightChild(idx) < numbers.len) {
            try std.testing.expect(number > numbers[rightChild(idx)]);
        }
    }
}

test "build max heap - random case" {
    var numbers = [_]i32{ 7, 1, 9, 3, 11 };
    buildMaxHeap(&numbers);
    for (numbers, 0..) |number, idx| {
        if (leftChild(idx) < numbers.len) {
            try std.testing.expect(number > numbers[leftChild(idx)]);
        }
        if (rightChild(idx) < numbers.len) {
            try std.testing.expect(number > numbers[rightChild(idx)]);
        }
    }
}

test "build max heap - single element case" {
    var numbers = [_]i32{5};
    buildMaxHeap(&numbers);
    const expectedNumbers = [_]i32{5};
    try std.testing.expect(std.mem.eql(i32, &numbers, &expectedNumbers));
}

test "heap sort - trivial case" {
    var numbers = [_]i32{ 1, 2, 3, 4 };
    heapSort(&numbers);
    const expectedNumbers = [_]i32{ 1, 2, 3, 4 };
    try std.testing.expect(std.mem.eql(i32, &numbers, &expectedNumbers));
}

test "heap sort - reverse case" {
    var numbers = [_]i32{ 4, 3, 2, 1 };
    heapSort(&numbers);
    const expectedNumbers = [_]i32{ 1, 2, 3, 4 };
    try std.testing.expect(std.mem.eql(i32, &numbers, &expectedNumbers));
}

test "heap sort - empty case" {
    var numbers = [_]i32{};
    heapSort(&numbers);
    const expectedNumbers = [_]i32{};
    try std.testing.expect(std.mem.eql(i32, &numbers, &expectedNumbers));
}

test "heap sort - single entry case" {
    var numbers = [_]i32{5};
    heapSort(&numbers);
    const expectedNumbers = [_]i32{5};
    try std.testing.expect(std.mem.eql(i32, &numbers, &expectedNumbers));
}

test "heap sort - random numbers" {
    const DEBUG = false;
    const RUN_NUMBER = 100;

    for (0..RUN_NUMBER) |_| {
        var numbers: [100]i32 = undefined;
        util.randomiseIntegers(&numbers, 100);
        if (DEBUG) {
            std.debug.print("Before sorting: ", .{});
            util.printNumbers(&numbers);
        }

        heapSort(&numbers);
        if (DEBUG) {
            std.debug.print("After sorting: ", .{});
            util.printNumbers(&numbers);
        }

        for (1..numbers.len) |idx| {
            try std.testing.expect(numbers[idx] >= numbers[idx - 1]);
        }
    }
}
