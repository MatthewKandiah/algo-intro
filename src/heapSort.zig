const std = @import("std");

fn Heap(comptime capacity: usize) type {
    return struct {
        data: [capacity]i32,
        size: usize = 0,

        fn init(data: [capacity]i32, size: usize) Heap(capacity) {
            return Heap(capacity){
                .data = data,
                .size = size,
            };
        }
    };
}

fn left(i: usize) usize {
    return 2 * i + 1;
}

fn right(i: usize) usize {
    return left(i) + 1;
}

// assume children at left(i) and right(i) are max heaps, rearrange such that i is the root of a valid max heap
fn maxHeapify(comptime capacity: usize, heap: *Heap(capacity), i: usize) void {
    const l = left(i);
    const r = right(i);

    var largest: usize = undefined;
    if (l < heap.size and heap.data[l] > heap.data[i]) {
        largest = l;
    } else {
        largest = i;
    }
    if (r < heap.size and heap.data[r] > heap.data[largest]) {
        largest = r;
    }

    if (largest != i) {
        const tmp = heap.data[i];
        heap.data[i] = heap.data[largest];
        heap.data[largest] = tmp;
        maxHeapify(capacity, heap, largest);
    }
}

test "maxHeapify should work on 1 element tree" {
    const capacity: comptime_int = 5;
    const startingData = [capacity]i32{ 1, 2, 3, 4, 5 };
    var heap = Heap(capacity).init(startingData, 1);

    maxHeapify(capacity, &heap, 0);

    try std.testing.expectEqualSlices(i32, &startingData, &heap.data);
}

test "maxHeapify should work on 2 element tree" {
    const capacity: comptime_int = 5;
    const startingData = [capacity]i32{1,2,3,4,5};
    var heap = Heap(capacity).init(startingData, 2);

    maxHeapify(capacity, &heap, 0);

    const expectedData = [capacity]i32{2,1,3,4,5};
    try std.testing.expectEqualSlices(i32, &expectedData, &heap.data);
}

test "maxHeapify should work on 3 element tree" {
    const capacity: comptime_int = 5;
    const startingData = [capacity]i32{1,2,3,4,5};
    var heap = Heap(capacity).init(startingData, 3);
    
    maxHeapify(capacity, &heap, 0);

    const expectedData = [capacity]i32{3,2,1,4,5};
    try std.testing.expectEqualSlices(i32, &expectedData, &heap.data);
}

test "maxHeapify should work on large tree" {
    const capacity: comptime_int = 10;
    const startingData = [capacity]i32{1, 10,9,7,8,5,6,4,3,2};
    var heap = Heap(capacity).init(startingData, 10);

    maxHeapify(capacity, &heap, 0);

    const expectedData = [capacity]i32{10,8,9,7,2,5,6,4,3,1};
    try std.testing.expectEqualSlices(i32, &expectedData, &heap.data);
}

test "maxHeapify should work without touching higher nodes" {
    const capacity: comptime_int = 10;
    const startingData = [capacity]i32{1,2,3,10,9,8,7,6,5,4};
    var heap = Heap(capacity).init(startingData, 10);

    maxHeapify(capacity, &heap, 1);

    const expectedData = [capacity]i32{1,10,3,6,9,8,7,2,5,4};
    try std.testing.expectEqualSlices(i32, &expectedData, &heap.data);
}

// TODO - buildMaxHeap and heapSort
