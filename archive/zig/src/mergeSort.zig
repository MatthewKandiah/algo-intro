const std = @import("std");
const util = @import("util.zig");

// Assuming numbers[x..y] and numbers[y..z] are sorted subarrays,
// combine them s.t numbers[x..z] is a sorted subarray.
// Requires x <= y <= z
fn merge(numbers: []i32, x: usize, y: usize, z: usize) !void {
    // copy left and right subarrays
    const lSize: usize = y - x;
    const rSize: usize = z - y;
    // pretty sure these have to be heap allocated if we want to allow for unspecified array sizes
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinitStatus = gpa.deinit();
        if (deinitStatus == .leak) @panic("Memory leak from GPA");
    }
    var l: []i32 = try allocator.alloc(i32, lSize);
    defer allocator.free(l);
    @memcpy(l, numbers[x..y]);
    var r: []i32 = try allocator.alloc(i32, rSize);
    defer allocator.free(r);
    @memcpy(r, numbers[y..z]);

    // iterate through left and right sub arrays, repopulate original array in sorted order
    var lIdx: usize = 0;
    var rIdx: usize = 0;
    var insertIdx: usize = x;
    while (lIdx < lSize and rIdx < rSize) {
        if (l[lIdx] < r[rIdx]) {
            numbers[insertIdx] = l[lIdx];
            lIdx += 1;
        } else {
            numbers[insertIdx] = r[rIdx];
            rIdx += 1;
        }
        insertIdx += 1;
    }

    // flush remaining elements
    for (l[lIdx..]) |num| {
        numbers[insertIdx] = num;
        insertIdx += 1;
    }

    for (r[rIdx..]) |num| {
        numbers[insertIdx] = num;
        insertIdx += 1;
    }
}

fn mergeSortRange(numbers: []i32, x: usize, z: usize) !void {
    if (z - x <= 1) return;
    const y: usize = (x + z) / 2;
    try mergeSortRange(numbers, x, y);
    try mergeSortRange(numbers, y, z);
    try merge(numbers, x, y, z);
}

pub fn mergeSort(numbers: []i32) !void {
    try mergeSortRange(numbers, 0, numbers.len);
}

test "merge sort - trivial case" {
    var numbers = [_]i32{ 1, 2, 3, 4 };
    try mergeSort(&numbers);
    const expectedNumbers = [_]i32{ 1, 2, 3, 4 };
    try std.testing.expect(std.mem.eql(i32, &numbers, &expectedNumbers));
}

test "merge sort - reverse case" {
    var numbers = [_]i32{ 4, 3, 2, 1 };
    try mergeSort(&numbers);
    const expectedNumbers = [_]i32{ 1, 2, 3, 4 };
    try std.testing.expect(std.mem.eql(i32, &numbers, &expectedNumbers));
}

test "merge sort - empty case" {
    var numbers = [_]i32{};
    try mergeSort(&numbers);
    const expectedNumbers = [_]i32{};
    try std.testing.expect(std.mem.eql(i32, &numbers, &expectedNumbers));
}

test "merge sort - single entry case" {
    var numbers = [_]i32{5};
    try mergeSort(&numbers);
    const expectedNumbers = [_]i32{5};
    try std.testing.expect(std.mem.eql(i32, &numbers, &expectedNumbers));
}

test "merge sort - random numbers" {
    const DEBUG = false;
    const RUN_NUMBER = 100;

    for (0..RUN_NUMBER) |_| {
        var numbers: [100]i32 = undefined;
        util.randomiseIntegers(&numbers, 100);
        if (DEBUG) {
            std.debug.print("Before sorting: ", .{});
            util.printNumbers(&numbers);
        }

        try mergeSort(&numbers);
        if (DEBUG) {
            std.debug.print("After sorting: ", .{});
            util.printNumbers(&numbers);
        }

        for (1..numbers.len) |idx| {
            try std.testing.expect(numbers[idx] >= numbers[idx - 1]);
        }
    }
}
