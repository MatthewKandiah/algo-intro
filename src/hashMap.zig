const std = @import("std");
const linkedList = @import("linkedList.zig");

fn HashMap(comptime size: usize, comptime T: type) type {
    return struct {
        table: [size]linkedList.DoublyLinkedList(T),
        // TODO hashFunction property?

        const Self = @This();

        fn init(allocator: std.mem.Allocator) Self {
            return Self{
                .table = [1]linkedList.DoublyLinkedList(T){linkedList.DoublyLinkedList(T).init(allocator)} ** size,
            };
        }

        fn deinit(self: Self) void {
            for (self.table) |list| {
                list.deinit();
            }
        }
    };
}

test "should not memory leak" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) @panic("Memory leak");
    }

    var hashMap = HashMap(10, i32).init(allocator);
    _ = try hashMap.table[0].prepend(2); // arbitrarily allocate some memory
    hashMap.deinit();
}
