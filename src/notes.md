# Zig Language
## Pointers
There are 5 types of pointers:
1. `*T` - single-item pointer, supports pointer dereferencing `ptr.*`. This is the type returned by `&x`.
2. `[*]T` - many-item pointer, supports index syntax `ptr[i]`, supports slice syntax `ptr[start..end]`, supports pointer arithmetic `ptr + x`/`ptr - x`, requires T to have a known size.
3. `*[N]T` - single-item pointer to N-array( equivalently, a pointer to N items), supports index syntax `ptr[i]`, supports slice syntax `ptr[start..end]`, supports length property `ptr.len`
4. `[]T` - slice (aka "fat pointer"), contains a many-item pointer `[*]T` and a length, supports index syntax `slice[i]`, supports slice syntax `slice[start..end]`, supports length property `slice.len`
5. `[*:x]T` - sentinel-terminated pointer, a many-item pointer whose length is determined by a sentinal value (e.g. a C-string would be typed `[*:0]u8`), useful to know, but it is generally recommended to use slices instead if possible

## Pointer Arithmetic
- It's interesting that a single-item pointer does not support pointer arithmetic. 
- It is recommended that you use a many-item pointer directly for pointer arithmetic, if you do pointer arithmetic on a slice's pointer you need to update its length, or it will be left in a corrupted state.

# Sorting
## Bubble sort
- Really simple
- Quadratic time complexity
- Compare element `i` with element `i+1`, and swap if it is greater. This pushes maximum element to the final index. Shrink working array to not include maximum element and repeat. After each iteration the next largest value is added to the sort sub-array at the end of the target array. 

## Insertion sort
- Also pretty simple
- Quadratic time complexity
- Maintain a sorted sub-array on the left of the target array. Iterate backwards through the sorted sub-array, and insert the element into the correct position. The sorted sub-array is now one element longer. Repeat until the whole target array is sorted.

## Heap sort
- N*log(N) time complexity
- first turn the array into a max heap (this up front cost might make this slower for small arrays, but scales well for large arrays)
- swap the first and last elements of heap (we now know the max element is at the end of the array, and a small element is at the front)
- decrement heap size by one and "max-heapify" from the root again, the next largest element will bubble to the top
- repeat through the whole array, we are building a sorted sub-array at the back of the array

## Quick sort
- N*log(N) time on average, N^2 in worst case.
- Sorts in place using a divide and conquer strategy.
- Identify a pivot element. Rearrange the array into a low side and a high side with the pivot in between. Every element in the low side is less than or equal to the pivot. Every element in the high side is greater than or equal to the pivot. Repeat this on the low side and the high side, keep doing this until you have sorted the whole array!

### Time complexity
- max-heapifying at a given node is O(log(N))
- build max heap has O(N) steps, each calling max-heapify, so it's O(N*log(N))
- heap-sort then has O(N) steps, each calling max-heapify, so that part is also O(N*log(N))
- total time complexity is therefore O(N*log(N))

# Matrix Multiplication
## Simple square matrices
- Super simple
- Basically just the definition of matrix multiplication
- Cubic time complexity

## Simple recursive square matrices
- A "divide and conquer" strategy
- Cubic time complexity
- Only applicable to square matrices whose dimension is an exact power of 2 
- An exercise to come back to, relax the input condition to allow multiplication of square matrices of arbitrary dimension of arbitrary dimension. Some thoughts:
    - Could relax the base case to just do a standard matrix multiplication when the sub-matrix dimension is odd. Bit rubbish, simplifies to our non-recursive method for half of all numbers. Presumably this recursive method is useful for parallelising the calculation, which this method would be pretty rubbish for.
    - Could pad with zeros, force the inputs to have dimensions which are an exact power of 2? Also feels pretty rubbish, we significantly increase our memory usage, and our number of operations jumps sharply when the dimension is increased just past a power of 2. If parallelising is the goal and we're going to run on many cores, maybe this is a decent solution though? 
    - Be smarter in the splitting strategy. This is almost definitely what they are looking for but I'm struggling to see how you could divide an odd square matrix such that the dimensions allow for all the sub-matrix multiplications we need.
