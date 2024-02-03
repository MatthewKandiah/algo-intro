const std = @import("std");

fn quickSort(slice: []i32) void {
    if (slice.len > 0) {
        const keyIndex = partition(slice);
        quickSort(slice[0..keyIndex]);
        quickSort(slice[keyIndex+1..]);
    }
}

fn partition(slice: []i32) usize {
    const key = slice[slice.len - 1];
    var lowSideHead: usize = 0;
    for (0..slice.len-1) |i| {
        if (slice[i] <= key) {
            const tmp = slice[lowSideHead];
            slice[lowSideHead] = slice[i];
            slice[i] = tmp;
            lowSideHead += 1;
        }
    }
    slice[slice.len-1] = slice[lowSideHead];
    slice[lowSideHead] = key;
    return lowSideHead;
}

test "quickSort should work" {
    var a = [_]i32{1,2,3,4,5};
    var b = [_]i32{5,4,3,2,1};
    var c = [_]i32{2,4,1,5,3};

    quickSort(&a);
    quickSort(&b);
    quickSort(&c);

    const expected = [_]i32{1,2,3,4,5};
    try std.testing.expectEqualSlices(i32, &expected, &a);
    try std.testing.expectEqualSlices(i32, &expected, &b);
    try std.testing.expectEqualSlices(i32, &expected, &c);
}

test "quickSort should work for one element array" {
    var a = [_]i32{1};

    quickSort(&a);

    const expected = [_]i32{1};
    try std.testing.expectEqualSlices(i32, &expected, &a);
}

test "quickSort should work for empty array" {
    var empty = [_]i32{};

    quickSort(&empty);

    const expected = [_]i32{};
    try std.testing.expectEqualSlices(i32, &expected, &empty);
}

test "quickSort should work on a larger array" {
    var a: [10000]i32 = undefined;
    var prng = std.rand.DefaultPrng.init(42);
    for (0..a.len) |i| {
        a[i] = prng.random().int(i32);
    }

    quickSort(&a);

    for (1..a.len) |i| {
        try std.testing.expect(a[i] >= a[i - 1]);
    }
}
