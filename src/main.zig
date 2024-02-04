const std = @import("std");

pub fn main() void {
    std.debug.print("Executable does nothing yet. Use `zig test src/lib.zig` to run all unit tests, or `zig test <path to source file>` to run specific tests", .{});
}

test "should pass" {
    try std.testing.expect(true);
}

test "should fail" {
    try std.testing.expect(false);
}
