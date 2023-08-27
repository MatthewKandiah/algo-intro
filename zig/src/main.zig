const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) {
            @panic("Memory leak in general purpose allocator deinit.");
        }
    }

    const args_alloc = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args_alloc);

    if (args_alloc.len < 2) {
        std.debug.print("Usage:\n\tmain -f input_path\nor\n\tmain [integers to sort]", .{});
        return;
    }

    if (std.mem.eql(u8, args_alloc[1], "-f")) {
        if (args_alloc.len != 3) {
            std.debug.print("Usage: -f expected to be followed by single argument for input file path\n", .{});
            return;
        }
        std.debug.print("sort integers found in {s}\n", .{args_alloc[2]});
        return;
    }

    std.debug.print("sort integers:\n", .{});
    for (args_alloc, 0..) |arg, i| {
        if (i == 0) continue;
        std.debug.print("{d}. {s}\n", .{i, arg});
    }
    return;
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
