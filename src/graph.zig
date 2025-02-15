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

        // NOTE - using in-out arguments to avoid the need to pass in a memory allocator, if we want to do any performance profiling, it's nice to avoid allocations muddying results!
        // set distances to array res where res[i] is the distance from source to i, null if unreachable
        // set parents to array res where res[i] is the parent of node i on the identified shortest path from source to i
        pub fn bfs(self: Self, source: usize, distances: *[V]?usize, parents: *[V]?usize) void {
            var colours: [V]Colour = .{.White} ** V;
            for (distances) |*d| {
                d.* = null;
            }
            for (parents) |*p| {
                p.* = null;
            }
            colours[source] = .Grey;
            distances[source] = 0;
            var queue = Queue(V).init();
            queue.enqueue(source);
            while (queue.size > 0) {
                const current_vertex = queue.dequeue();
                const adj_list = self.getAdjacencyList(current_vertex);
                for (0..V) |i| {
                    if (adj_list[i] and colours[i] == .White) {
                        colours[i] = .Grey;
                        distances[i] = (distances[current_vertex] orelse @panic("Will never happen")) + 1;
                        parents[i] = current_vertex;
                        queue.enqueue(i);
                    }
                }
                colours[current_vertex] = .Black;
            }
        }

        pub fn dfs(self: Self, discovers: *[V]?usize, finishes: *[V]?usize, parents: *[V]?usize) void {
            var colours: [V]Colour = .{.White} ** V;
            for (discovers) |*d| {
                d.* = null;
            }
            for (finishes) |*f| {
                f.* = null;
            }
            for (parents) |*p| {
                p.* = null;
            }
            var time: usize = 0;

            for (0..V) |i| {
                if (colours[i] == .White) {
                    dfsAux(self, i, &time, discovers, finishes, parents, &colours);
                }
            }
        }

        fn dfsAux(self: Self, current_vertex: usize, time: *usize, discovers: *[V]?usize, finishes: *[V]?usize, parents: *[V]?usize, colours: *[V]Colour) void {
            time.* += 1;
            discovers[current_vertex] = time.*;
            colours[current_vertex] = .Grey;
            const adj_list = self.getAdjacencyList(current_vertex);
            for (0..V) |i| {
                if (adj_list[i] and colours[i] == .White) {
                    parents[i] = current_vertex;
                    dfsAux(self, i, time, discovers, finishes, parents, colours);
                }
            }
            time.* += 1;
            finishes[current_vertex] = time.*;
            colours[current_vertex] = .Black;
        }
    };
}

const Colour = enum {
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
            std.mem.copyForwards(usize, self.data[0 .. self.size - 1], self.data[1..self.size]);
            self.size -= 1;
            return res;
        }
    };
}

test "should set vertex adjacency list" {
    var graph_buf: [9]bool = undefined;
    var graph = Graph(3).init(&graph_buf);
    graph.setAdjacencyList(0, .{ false, false, false });
    graph.setAdjacencyList(1, .{ true, false, true });
    graph.setAdjacencyList(2, .{ false, false, false });

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

    var distances: [9]?usize = undefined;
    var parents: [9]?usize = undefined;
    graph.bfs(4, &distances, &parents);

    try std.testing.expectEqualSlices(?usize, &.{ 2, 1, 2, 1, 0, 1, 2, 3, 3 }, &distances);
    try std.testing.expectEqualSlices(?usize, &.{ 1, 4, 1, 4, null, 4, 3, 2, 6 }, &parents);
}

test "should get correct breadth first search result with unreachable nodes" {
    var graph_buf: [81]bool = undefined;
    var graph = Graph(9).init(&graph_buf);
    graph.setAdjacencyList(0, .{ false, true, false, true, false, false, false, false, false });
    graph.setAdjacencyList(1, .{ true, false, true, false, true, false, false, false, false });
    graph.setAdjacencyList(2, .{ false, true, false, false, false, true, false, true, false });
    graph.setAdjacencyList(3, .{ true, false, false, false, true, false, true, false, false });
    graph.setAdjacencyList(4, .{ false, true, false, true, false, true, false, false, false });
    graph.setAdjacencyList(5, .{ false, false, true, false, true, false, true, false, false });
    graph.setAdjacencyList(6, .{ false, false, false, true, false, true, false, true, false });
    graph.setAdjacencyList(7, .{ false, false, true, false, false, false, true, false, false });
    graph.setAdjacencyList(8, .{ false, false, false, false, false, false, false, false, false });

    var distances: [9]?usize = undefined;
    var parents: [9]?usize = undefined;
    graph.bfs(4, &distances, &parents);

    try std.testing.expectEqualSlices(?usize, &.{ 2, 1, 2, 1, 0, 1, 2, 3, null }, &distances);
    try std.testing.expectEqualSlices(?usize, &.{ 1, 4, 1, 4, null, 4, 3, 2, null }, &parents);
}

test "should get correct depth first search result" {
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

    var discovers: [9]?usize = undefined;
    var finishes: [9]?usize = undefined;
    var parents: [9]?usize = undefined;
    graph.dfs(&discovers, &finishes, &parents);

    try std.testing.expectEqualSlices(?usize, &.{ 1, 2, 3, 6, 5, 4, 7, 8, 9 }, &discovers);
    try std.testing.expectEqualSlices(?usize, &.{ 18, 17, 16, 13, 14, 15, 12, 11, 10 }, &finishes);
    try std.testing.expectEqualSlices(?usize, &.{ null, 0, 1, 4, 5, 2, 3, 6, 7 }, &parents);
}
