const std = @import("std");

pub fn main() void {
    std.debug.print("Executable does nothing yet. Use `zig test <path to source>` to run unit tests. Writing a build step that runs all the tests is on the todo list!", .{});
}

test "should pass" {
    try std.testing.expect(true);
}

test "should fail" {
    try std.testing.expect(false);
}
