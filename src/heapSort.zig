const std = @import("std");

fn heapSort(data: []i32) void {
    buildMaxHeap(data);
    var heapSize = data.len;
    while (heapSize > 0) {
        const tmp = data[0];
        data[0] = data[heapSize - 1];
        data[heapSize - 1] = tmp;

        heapSize -= 1;
        maxHeapify(data[0..heapSize], 0);
    }
}

test "heapSort should work" {
    var a = [5]i32{ 1, 2, 3, 4, 5 };
    var b = [5]i32{ 5, 4, 3, 2, 1 };
    var c = [5]i32{ 2, 3, 5, 1, 4 };

    heapSort(&a);
    heapSort(&b);
    heapSort(&c);

    const expected = [5]i32{ 1, 2, 3, 4, 5 };
    try std.testing.expectEqualSlices(i32, &expected, &a);
    try std.testing.expectEqualSlices(i32, &expected, &b);
    try std.testing.expectEqualSlices(i32, &expected, &c);
}

test "heapSort should work for single element array" {
    var a = [1]i32{1};

    heapSort(&a);

    const expected = [1]i32{1};
    try std.testing.expectEqualSlices(i32, &expected, &a);
}

test "heapSort should work for empty array" {
    var a = [0]i32{};

    heapSort(&a);

    const expected = [0]i32{};
    try std.testing.expectEqualSlices(i32, &expected, &a);
}

test "heapSort should work for long array" {
    var a: [10000]i32 = undefined;
    var prng = std.rand.DefaultPrng.init(42);
    for (0..a.len) |i| {
        a[i] = prng.random().int(i32);
    }

    heapSort(&a);

    for (1..a.len) |i| {
        try std.testing.expect(a[i] >= a[i - 1]);
    }
}

fn buildMaxHeap(data: []i32) void {
    for (0..data.len / 2 + 1) |i| {
        maxHeapify(data, data.len / 2 - i);
    }
}

fn maxHeapify(heap: []i32, rootIdx: usize) void {
    const leftIdx = 2 * rootIdx + 1;
    const rightIdx = leftIdx + 1;
    var largestIdx: usize = undefined;
    if (leftIdx < heap.len and heap[leftIdx] > heap[rootIdx]) {
        largestIdx = leftIdx;
    } else {
        largestIdx = rootIdx;
    }
    if (rightIdx < heap.len and heap[rightIdx] > heap[largestIdx]) {
        largestIdx = rightIdx;
    }

    if (largestIdx != rootIdx) {
        const tmp = heap[rootIdx];
        heap[rootIdx] = heap[largestIdx];
        heap[largestIdx] = tmp;

        maxHeapify(heap, largestIdx);
    }
}

test "maxHeapify should work on 1 element tree without touching rest of array" {
    var array = [5]i32{ 1, 2, 3, 4, 5 };
    var heap = array[0..1];

    maxHeapify(heap, 0);

    const expectedArray = [5]i32{ 1, 2, 3, 4, 5 };
    try std.testing.expectEqualSlices(i32, &expectedArray, &array);
}

test "maxHeapify should work on 2 element tree without touching rest of array" {
    var array = [5]i32{ 1, 2, 3, 4, 5 };
    var heap = array[0..2];

    maxHeapify(heap, 0);

    const expectedArray = [5]i32{ 2, 1, 3, 4, 5 };
    try std.testing.expectEqualSlices(i32, &expectedArray, &array);
}

test "maxHeapify should work on 3 element tree without touching rest of array" {
    var array = [5]i32{ 1, 2, 3, 4, 5 };
    var heap = array[0..3];

    maxHeapify(heap, 0);

    const expectedArray = [5]i32{ 3, 2, 1, 4, 5 };
    try std.testing.expectEqualSlices(i32, &expectedArray, &array);
}

test "maxHeapify should work on large tree" {
    var array = [10]i32{ 1, 10, 9, 7, 8, 5, 6, 4, 3, 2 };
    var heap = array[0..10];

    maxHeapify(heap, 0);

    const expectedArray = [10]i32{ 10, 8, 9, 7, 2, 5, 6, 4, 3, 1 };
    try std.testing.expectEqualSlices(i32, &expectedArray, &array);
}

test "maxHeapify should work without touching higher nodes" {
    var array = [10]i32{ 1, 2, 3, 10, 9, 8, 7, 6, 5, 4 };
    var heap = array[0..10];

    maxHeapify(heap, 1);

    const expectedArray = [10]i32{ 1, 10, 3, 6, 9, 8, 7, 2, 5, 4 };
    try std.testing.expectEqualSlices(i32, &expectedArray, &array);
}

// buildMaxHeap
