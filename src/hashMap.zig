const std = @import("std");
const linkedList = @import("linkedList.zig");

fn HashFunction(comptime T: type) type {
    return *const fn (key: T) usize;
}

fn HashMap(comptime size: usize, comptime K: type, comptime T: type) type {
    return struct {
        table: [size]linkedList.DoublyLinkedList(K, T),
        hash: HashFunction(K),

        const Self = @This();

        fn init(allocator: std.mem.Allocator, hash: HashFunction(K)) Self {
            return Self{
                .table = [1]linkedList.DoublyLinkedList(K, T){linkedList.DoublyLinkedList(K, T).init(allocator)} ** size,
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

        fn insert(self: *Self, key: K, value: T) !*linkedList.Node(K, T) {
            return try self.table[self.index(key)].prepend(key, value);
        }

        fn put(self: *Self, key: K, value: T) !*linkedList.Node(K, T) {
            if (self.search(key)) |found| {
                found.record.value = value;
                return found;
            }
            return try self.insert(key, value);
        }

        fn search(self: *const Self, key: K) ?*linkedList.Node(K, T) {
            return self.table[self.index(key)].search(key);
        }

        fn delete(self: *Self, node: *linkedList.Node(K, T)) void {
            self.table[self.index(node.record.key)].delete(node);
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

fn firstLetterHash(str: [*]const u8) usize {
    return switch (str[0]) {
        'a', 'A' => 1,
        'b', 'B' => 2,
        'c', 'C' => 3,
        'd', 'D' => 4,
        'e', 'E' => 5,
        'f', 'F' => 6,
        'g', 'G' => 7,
        'h', 'H' => 8,
        'i', 'I' => 9,
        'j', 'J' => 10,
        'k', 'K' => 11,
        'l', 'L' => 12,
        'm', 'M' => 13,
        'n', 'N' => 14,
        'o', 'O' => 15,
        'p', 'P' => 16,
        'q', 'Q' => 17,
        'r', 'R' => 18,
        's', 'S' => 19,
        't', 'T' => 20,
        'u', 'U' => 21,
        'v', 'V' => 22,
        'w', 'W' => 23,
        'x', 'X' => 24,
        'y', 'Y' => 25,
        'z', 'Z' => 26,
        else => 0,
    };
}

test "should not memory leak" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinitStatus = gpa.deinit();
        if (deinitStatus == .leak) @panic("Memory leak");
    }

    var hashMap = HashMap(10, i32, u8).init(allocator, rubbishHash);
    _ = try hashMap.table[0].prepend(1, 2); // arbitrarily allocate some memory
    hashMap.deinit();
}

test "should insert new value" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinitStatus = gpa.deinit();
        if (deinitStatus == .leak) @panic("Memory leak");
    }

    var hashMap = HashMap(10, i32, u16).init(allocator, trivialHash);
    defer {
        hashMap.deinit();
    }
    _ = try hashMap.insert(2, 12);

    try std.testing.expectEqual(@as(u16, 12), hashMap.table[2].head.?.record.value);
}

test "should insert new value with table index wrapping" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinitStatus = gpa.deinit();
        if (deinitStatus == .leak) @panic("Memory leak");
    }

    var hashMap = HashMap(10, i32, u16).init(allocator, trivialHash);
    defer {
        hashMap.deinit();
    }
    _ = try hashMap.insert(12, 12);

    try std.testing.expectEqual(@as(u16, 12), hashMap.table[2].head.?.record.value);
}

test "should insert string keys and values" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinitStatus = gpa.deinit();
        if (deinitStatus == .leak) @panic("Memory leak");
    }

    var hashMap = HashMap(27, [*]const u8, [*]const u8).init(allocator, firstLetterHash);
    defer {
        hashMap.deinit();
    }
    _ = try hashMap.insert("antelope", "Barry");
    _ = try hashMap.insert("bee", "Stephen");
    _ = try hashMap.insert("cat", "Darren");
    _ = try hashMap.insert("dog", "Jeff");

    const RecordStringString = linkedList.Record([*]const u8, [*]const u8);
    try std.testing.expectEqual(RecordStringString{ .key = "antelope", .value = "Barry" }, hashMap.table[1].head.?.record);
    try std.testing.expectEqual(RecordStringString{ .key = "bee", .value = "Stephen" }, hashMap.table[2].head.?.record);
    try std.testing.expectEqual(RecordStringString{ .key = "cat", .value = "Darren" }, hashMap.table[3].head.?.record);
    try std.testing.expectEqual(RecordStringString{ .key = "dog", .value = "Jeff" }, hashMap.table[4].head.?.record);
}

test "should insert values with hash collisions" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinitStatus = gpa.deinit();
        if (deinitStatus == .leak) @panic("Memory leak");
    }

    var hashMap = HashMap(5, i32, [*]const u8).init(allocator, trivialHash);
    defer {
        hashMap.deinit();
    }
    _ = try hashMap.insert(1, "first");
    _ = try hashMap.insert(1, "second");
    _ = try hashMap.insert(-1, "third");
    _ = try hashMap.insert(6, "fourth");

    const resultList = hashMap.table[1];
    const RecordIntString = linkedList.Record(i32, [*]const u8);
    try std.testing.expectEqualDeep(RecordIntString{ .key = 6, .value = "fourth" }, resultList.head.?.record);
    try std.testing.expectEqualDeep(RecordIntString{ .key = -1, .value = "third" }, resultList.head.?.next.?.record);
    try std.testing.expectEqualDeep(RecordIntString{ .key = 1, .value = "second" }, resultList.head.?.next.?.next.?.record);
    try std.testing.expectEqualDeep(RecordIntString{ .key = 1, .value = "first" }, resultList.head.?.next.?.next.?.next.?.record);
}

test "should search and return pointer to value node" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinitStatus = gpa.deinit();
        if (deinitStatus == .leak) @panic("Memory leak");
    }

    var hashMap = HashMap(27, [*]const u8, [*]const u8).init(allocator, firstLetterHash);
    defer {
        hashMap.deinit();
    }

    const larry = try hashMap.insert("dog", "Larry");
    const barry = try hashMap.insert("cat", "Barry");
    const harry = try hashMap.insert("rat", "Harry");

    try std.testing.expectEqual(larry, hashMap.search("dog").?);
    try std.testing.expectEqual(barry, hashMap.search("cat").?);
    try std.testing.expectEqual(harry, hashMap.search("rat").?);
    try std.testing.expectEqual(@as(?*linkedList.Node([*]const u8, [*]const u8), null), hashMap.search("something that isn't found"));
}

test "should search and return pointer in collision chain" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinitStatus = gpa.deinit();
        if (deinitStatus == .leak) @panic("Memory leak");
    }

    var hashMap = HashMap(27, [*]const u8, [*]const u8).init(allocator, firstLetterHash);
    defer {
        hashMap.deinit();
    }

    const larry = try hashMap.insert("dog", "Larry");
    const barry = try hashMap.insert("doggo", "Barry");
    const harry = try hashMap.insert("rat", "Harry");
    const carrie = try hashMap.insert("ratto", "Carrie");

    try std.testing.expectEqual(larry, hashMap.search("dog").?);
    try std.testing.expectEqual(barry, hashMap.search("doggo").?);
    try std.testing.expectEqual(harry, hashMap.search("rat").?);
    try std.testing.expectEqual(carrie, hashMap.search("ratto").?);
}

test "should delete value" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinitStatus = gpa.deinit();
        if (deinitStatus == .leak) @panic("Memory leak");
    }

    var hashMap = HashMap(10, i32, usize).init(allocator, trivialHash);
    defer {
        hashMap.deinit();
    }
    const nodeOne = try hashMap.insert(1, 11);
    const nodeTwo = try hashMap.insert(2, 22);

    hashMap.delete(nodeOne);

    try std.testing.expectEqual(@as(?*linkedList.Node(i32, usize), null), hashMap.search(1));
    try std.testing.expectEqual(nodeTwo, hashMap.search(2).?);
}

test "should delete values in collision chain" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinitStatus = gpa.deinit();
        if (deinitStatus == .leak) @panic("Memory leak");
    }

    var hashMap = HashMap(10, i32, usize).init(allocator, trivialHash);
    defer {
        hashMap.deinit();
    }
    const nodeOne = try hashMap.insert(1, 11);
    const nodeTwo = try hashMap.insert(-1, 22);

    hashMap.delete(nodeOne);

    try std.testing.expectEqual(@as(?*linkedList.Node(i32, usize), null), hashMap.search(1));
    try std.testing.expectEqual(nodeTwo, hashMap.search(-1).?);
}

test "should put a value - update if exists, else insert" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinitStatus = gpa.deinit();
        if (deinitStatus == .leak) @panic("Memory leak");
    }

    var hashMap = HashMap(5, i32, [*]const u8).init(allocator, trivialHash);
    defer {
        hashMap.deinit();
    }
    _ = try hashMap.put(1, "first");
    _ = try hashMap.put(1, "second");
    _ = try hashMap.put(-1, "third");
    _ = try hashMap.put(6, "fourth");

    const resultList = hashMap.table[1];
    const RecordIntString = linkedList.Record(i32, [*]const u8);
    try std.testing.expectEqualDeep(RecordIntString{ .key = 6, .value = "fourth" }, resultList.head.?.record);
    try std.testing.expectEqualDeep(RecordIntString{ .key = -1, .value = "third" }, resultList.head.?.next.?.record);
    try std.testing.expectEqualDeep(RecordIntString{ .key = 1, .value = "second" }, resultList.head.?.next.?.next.?.record);
    try std.testing.expectEqual(@as(?*linkedList.Node(i32, [*]const u8), null), resultList.head.?.next.?.next.?.next);
}
