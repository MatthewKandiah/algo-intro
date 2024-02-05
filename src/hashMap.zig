const std = @import("std");
const linkedList = @import("linkedList.zig");

fn HashFunction(comptime T: type) type {
    return *const fn (key: T) usize;
}

fn Record(comptime K: type, comptime T: type) type {
    return struct {
        key: K,
        value: T,
    };
}

fn HashMap(comptime size: usize, comptime K: type, comptime T: type) type {
    return struct {
        table: [size]linkedList.DoublyLinkedList(Record(K, T)),
        hash: HashFunction(K),

        const Self = @This();

        fn init(allocator: std.mem.Allocator, hash: HashFunction(K)) Self {
            return Self {
                .table = [1]linkedList.DoublyLinkedList(Record(K, T)){linkedList.DoublyLinkedList(Record(K, T)).init(allocator)} ** size,
                .hash = hash,
            };
        }

        fn deinit(self: Self) void {
            for (self.table) |list| {
                list.deinit();
            }
        }
    };
}

fn rubbishHash(_: i32) usize {
    return 1;
}

test "should not memory leak" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) @panic("Memory leak");
    }

    var hashMap = HashMap(10, i32, u8).init(allocator, rubbishHash);
    _ = try hashMap.table[0].prepend(.{.key = 1, .value = 2}); // arbitrarily allocate some memory
    hashMap.deinit();
}

test "should insert new value" {
    try std.testing.expect(false);
}

test "should insert values with hash collisions" {
    try std.testing.expect(false);
}

test "should search and return pointer to value node" {
    try std.testing.expect(false);
}

test "should search and return pointer in collision chain" {
    try std.testing.expect(false);
}

test "should delete value" {
    try std.testing.expect(false);
}

test "should delete values in collision chain" {
    try std.testing.expect(false);
}

test "should put a value - update if exists, else insert" {
    try std.testing.expect(false);
}
