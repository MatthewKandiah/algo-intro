const std = @import("std");
const linked_list = @import("linkedList.zig");

/// Vertices labelled [0, V-1]
/// Graph.adjacency_lists[i] = all vertices reachable along an edge from vertex i
pub fn Graph(comptime T: type, comptime V: comptime_int) type {
    return struct {
        adjacency_lists: [V]linked_list.DoublyLinkedList(usize, T),

        const Self = @This();

        pub fn init(allocator: std.mem.Allocator) Self {
            var lists: [V]linked_list.DoublyLinkedList(usize, T) = undefined;
            for (0..V) |i| {
                const list = linked_list.DoublyLinkedList(usize, T).init(allocator);
                lists[i] = list;
            }
            return Self{ .adjacency_lists = lists };
        }

        pub fn deinit(self: Self) void {
            for (self.adjacency_lists) |list| {
                list.deinit();
            }
        }

        pub fn set(self: *Self, vertex: usize, adjacent_vertices: []usize, data: []T) !void {
            if (self.adjacency_lists[vertex].head != null) {
                self.adjacency_lists[vertex].delete(self.adjacency_lists[vertex].head.?);
            }
            std.debug.assert(adjacent_vertices.len == data.len);
            for (0..adjacent_vertices.len) |j| {
                _ = try self.adjacency_lists[vertex].prepend(adjacent_vertices[j], data[j]);
            }
        }
    };
}

test "should not memory leak" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var graph = Graph(u8, 5).init(allocator);
    _ = try graph.adjacency_lists[0].prepend(1, 0);
    graph.deinit();

    const deinit_res = gpa.deinit();
    try std.testing.expectEqual(.ok, deinit_res);
}

test "should overwrite list for given vertex" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var graph = Graph(u8, 3).init(allocator);
    defer graph.deinit();

    var list0 = [_]usize{0};
    var data0 = [_]u8{0};
    var list1 = [_]usize{ 1, 2 };
    var data1 = [_]u8{ 10, 20 };
    var list2 = [_]usize{ 3, 4, 5 };
    var data2 = [_]u8{ 30, 40, 50 };

    try graph.set(0, &list0, &data0);
    try graph.set(2, &list1, &data1);
    try std.testing.expectEqual(graph.adjacency_lists[0].head.?.record.key, 0);
    try std.testing.expectEqual(graph.adjacency_lists[0].head.?.record.value, 0);
    try std.testing.expectEqual(graph.adjacency_lists[0].head.?.next, null);
    try std.testing.expectEqual(graph.adjacency_lists[1].head, null);
    try std.testing.expectEqual(graph.adjacency_lists[2].head.?.record.key, 2);
    try std.testing.expectEqual(graph.adjacency_lists[2].head.?.record.value, 20);
    try std.testing.expectEqual(graph.adjacency_lists[2].head.?.next.?.record.key, 1);
    try std.testing.expectEqual(graph.adjacency_lists[2].head.?.next.?.record.value, 10);
    try std.testing.expectEqual(graph.adjacency_lists[2].head.?.next.?.next, null);

    try graph.set(0, &list2, &data2);
    try std.testing.expectEqual(graph.adjacency_lists[0].head.?.record.key, 5);
    try std.testing.expectEqual(graph.adjacency_lists[0].head.?.record.value, 50);
    try std.testing.expectEqual(graph.adjacency_lists[0].head.?.next.?.record.key, 4);
    try std.testing.expectEqual(graph.adjacency_lists[0].head.?.next.?.record.value, 40);
    try std.testing.expectEqual(graph.adjacency_lists[0].head.?.next.?.next.?.record.key, 3);
    try std.testing.expectEqual(graph.adjacency_lists[0].head.?.next.?.next.?.record.value, 30);
    try std.testing.expectEqual(graph.adjacency_lists[0].head.?.next.?.next.?.next, null);
    try std.testing.expectEqual(graph.adjacency_lists[1].head, null);
    try std.testing.expectEqual(graph.adjacency_lists[2].head.?.record.key, 2);
    try std.testing.expectEqual(graph.adjacency_lists[2].head.?.record.value, 20);
    try std.testing.expectEqual(graph.adjacency_lists[2].head.?.next.?.record.key, 1);
    try std.testing.expectEqual(graph.adjacency_lists[2].head.?.next.?.record.value, 10);
    try std.testing.expectEqual(graph.adjacency_lists[2].head.?.next.?.next, null);
}
