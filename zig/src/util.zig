const std = @import("std");

pub fn printNumbers(numbers: []i32) void {
    for (numbers) |number| {
        std.debug.print("{d}, ", .{number});
    }
    std.debug.print("\n", .{});
}

pub fn randomiseIntegers(numbers: []i32, maxNumber: i32) void {
    var rng = std.rand.DefaultPrng.init(@bitCast(std.time.microTimestamp()));
    for (numbers) |*numberPtr| {
        numberPtr.* = @mod(rng.random().int(i32), maxNumber + 1);
    }
}

