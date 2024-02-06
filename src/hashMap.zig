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
            return Self{
                .table = [1]linkedList.DoublyLinkedList(Record(K, T)){linkedList.DoublyLinkedList(Record(K, T)).init(allocator)} ** size,
                .hash = hash,
            };
        }

        fn deinit(self: Self) void {
            for (self.table) |list| {
                list.deinit();
            }
        }

        fn index(self: *const Self, key: K) usize {
            return self.hash(key) % self.table.len;
        }

        fn insert(self: *Self, key: K, value: T) !void {
            const record = Record(K, T){ .key = key, .value = value };
            _ = try self.table[self.index(key)].prepend(record);
        }
    };
}

fn rubbishHash(_: i32) usize {
    return 1;
}

fn abs(value: i32) u32 {
    var result: u32 = undefined;
    if (value >= 0) {
        result = @intCast(value);
    } else {
        result = @intCast(-value);
    }
    return result;
}

fn trivialHash(value: i32) usize {
    return @intCast(abs(value));
}

fn firstLetterHash(str: [12]u8) usize {
    return switch (str[0]) {
        'a', 'A' => 0,
        'b', 'B' => 1,
        'c', 'C' => 2,
        'd', 'D' => 3,
        'e', 'E' => 4,
        'f', 'F' => 5,
        'g', 'G' => 6,
        'h', 'H' => 7,
        'i', 'I' => 8,
        'j', 'J' => 9,
        'k', 'K' => 10,
        'l', 'L' => 11,
        'm', 'M' => 12,
        'n', 'N' => 13,
        'o', 'O' => 14,
        'p', 'P' => 15,
        'q', 'Q' => 16,
        'r', 'R' => 17,
        's', 'S' => 18,
        't', 'T' => 19,
        'u', 'U' => 20,
        'v', 'V' => 21,
        'w', 'W' => 22,
        'x', 'X' => 23,
        'y', 'Y' => 24,
        'z', 'Z' => 25,
        else => 26,
    };
}

test "should not memory leak" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) @panic("Memory leak");
    }

    var hashMap = HashMap(10, i32, u8).init(allocator, rubbishHash);
    _ = try hashMap.table[0].prepend(.{ .key = 1, .value = 2 }); // arbitrarily allocate some memory
    hashMap.deinit();
}

test "should insert new value" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) @panic("Memory leak");
    }

    var hashMap = HashMap(10, i32, u16).init(allocator, trivialHash);
    defer {
        hashMap.deinit();
    }
    _ = try hashMap.insert(2, 12);

    try std.testing.expectEqual(@as(u16, 12), hashMap.table[2].head.?.key.value);
}

test "should insert new value with table index wrapping" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) @panic("Memory leak");
    }

    var hashMap = HashMap(10, i32, u16).init(allocator, trivialHash);
    defer {
        hashMap.deinit();
    }
    _ = try hashMap.insert(12, 12);

    try std.testing.expectEqual(@as(u16, 12), hashMap.table[2].head.?.key.value);
}

// test "should insert values with hash collisions" {
//     try std.testing.expect(false);
// }
//
// test "should search and return pointer to value node" {
//     try std.testing.expect(false);
// }
//
// test "should search and return pointer in collision chain" {
//     try std.testing.expect(false);
// }
//
// test "should delete value" {
//     try std.testing.expect(false);
// }
//
// test "should delete values in collision chain" {
//     try std.testing.expect(false);
// }
//
// test "should put a value - update if exists, else insert" {
//     try std.testing.expect(false);
// }
