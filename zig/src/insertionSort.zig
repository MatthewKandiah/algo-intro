const std = @import("std");

fn insertionSort(_: []i32) void {
    std.debug.print("runInsertionSort\n", .{});
}

fn randomiseIntegers(numbers: []i32) void {
    const rng = std.rand.DefaultPrng.init(std.time.microTimestamp());
    for (numbers) |*numberPtr| {
        numberPtr.* = rng.random();
    }
}

test "insertion sort - trivial case" {
    var numbers = [_]i32 {1, 2, 3, 4, 5, 6, 7, 8 ,9};
    insertionSort(&numbers);
    var expectedNumbers = [_]i32 {1, 2, 3, 4, 5, 6, 7, 8, 9};
    try std.testing.expect(std.mem.eql(i32, &numbers, &expectedNumbers));
}

