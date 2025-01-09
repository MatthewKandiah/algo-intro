const std = @import("std");

// uses zero-indexing for vertex labels
pub fn Graph(comptime V: usize) type {
    return struct {
        data: []bool,

        const Self = @This();

        pub fn init(buf: []bool) Self {
            std.debug.assert(buf.len == V * V);
            return Self{
                .data = buf,
            };
        }

        pub fn setAdjacencyList(self: *Self, vertex: usize, adj_list: [V]bool) void {
            const idx = vertex * V;
            for (0..V) |i| {
                self.data[idx + i] = adj_list[i];
            }
        }

        pub fn getAdjacencyList(self: Self, vertex: usize) []const bool {
            const idx = vertex * V;
            return self.data[idx .. idx + V];
        }

        // set distances to array res where res[i] is the distance from source to i, null if unreachable
        pub fn bfs(self: Self, source: usize, distances: *[V]?usize) void {
            var colours: [V]BfsColour = .{.White} ** V;
            for (distances) |*d| {
                d.* = null;
            }
            colours[source] = .Grey;
            distances[source] = 0;
            var queue = Queue(V).init();
            queue.enqueue(source);
            while (queue.size > 0) {
                std.debug.print("queue.size: {}, queue.data: {any}, distances: {any}\n", .{ queue.size, queue.data, distances });
                const current_vertex = queue.dequeue();
                const adj_list = self.getAdjacencyList(current_vertex);
                std.debug.print("current_vertex: {}, adj_list: {any}\n", .{ current_vertex, adj_list });
                for (0..V) |i| {
                    if (adj_list[i] and colours[i] == .White) {
                        colours[i] = .Grey;
                        distances[i] = (distances[current_vertex] orelse @panic("Will never happen")) + 1;
                        queue.enqueue(i);
                    }
                }
                colours[current_vertex] = .Black;
            }
        }
    };
}

const BfsColour = enum {
    White,
    Grey,
    Black,
};

fn Queue(comptime capacity: usize) type {
    return struct {
        data: [capacity]usize,
        size: usize,
        capacity: usize,

        const Self = @This();

        fn init() Self {
            return Self{
                .data = undefined,
                .size = 0,
                .capacity = capacity,
            };
        }

        fn enqueue(self: *Self, item: usize) void {
            if (self.size >= self.capacity) {
                @panic("Should never happen");
            }
            self.data[self.size] = item;
            self.*.size += 1;
        }

        fn dequeue(self: *Self) usize {
            if (self.size == 0) {
                @panic("Should never happen");
            }
            const res = self.data[0];
            std.debug.print("dequeue: before shift: {any}\n", .{self.data});
            std.mem.copyForwards(usize, self.data[0 .. self.size - 1], self.data[1..self.size]);
            std.debug.print("dequeue: after shift: {any}\n", .{self.data});
            self.size -= 1;
            return res;
        }
    };
}

test "should set vertex adjacency list" {
    var graph_buf: [9]bool = undefined;
    var graph = Graph(3).init(&graph_buf);
    graph.setAdjacencyList(0, .{false, false, false});
    graph.setAdjacencyList(1, .{ true, false, true });
    graph.setAdjacencyList(2, .{false, false, false});

    try std.testing.expectEqualSlices(bool, &.{ false, false, false, true, false, true, false, false, false }, graph.data);
}

test "should behave like a queue" {
    var queue = Queue(5).init();

    queue.enqueue(1);
    queue.enqueue(2);
    queue.enqueue(3);
    queue.enqueue(4);
    queue.enqueue(5);

    try std.testing.expectEqual(1, queue.dequeue());
    try std.testing.expectEqual(2, queue.dequeue());
    try std.testing.expectEqual(3, queue.dequeue());

    queue.enqueue(6);
    queue.enqueue(7);

    try std.testing.expectEqual(4, queue.dequeue());
    try std.testing.expectEqual(5, queue.dequeue());
    try std.testing.expectEqual(6, queue.dequeue());
    try std.testing.expectEqual(7, queue.dequeue());
}

test "should get vertex adjacency list" {
    var graph_buf: [9]bool = undefined;
    var graph = Graph(3).init(&graph_buf);
    graph.setAdjacencyList(1, .{ true, false, true });

    try std.testing.expectEqualSlices(bool, &.{ true, false, true }, graph.getAdjacencyList(1));
}

test "should get correct breadth first search result" {
    var graph_buf: [81]bool = undefined;
    var graph = Graph(9).init(&graph_buf);
    graph.setAdjacencyList(0, .{ false, true, false, true, false, false, false, false, false });
    graph.setAdjacencyList(1, .{ true, false, true, false, true, false, false, false, false });
    graph.setAdjacencyList(2, .{ false, true, false, false, false, true, false, true, false });
    graph.setAdjacencyList(3, .{ true, false, false, false, true, false, true, false, false });
    graph.setAdjacencyList(4, .{ false, true, false, true, false, true, false, false, false });
    graph.setAdjacencyList(5, .{ false, false, true, false, true, false, true, false, false });
    graph.setAdjacencyList(6, .{ false, false, false, true, false, true, false, true, true });
    graph.setAdjacencyList(7, .{ false, false, true, false, false, false, true, false, true });
    graph.setAdjacencyList(8, .{ false, false, false, false, false, false, true, true, false });

    var distances: [9]?usize = .{null} ** 9;
    graph.bfs(4, &distances);

    try std.testing.expectEqualSlices(?usize, &.{ 2, 1, 2, 1, 0, 1, 2, 3, 3 }, &distances);
}
