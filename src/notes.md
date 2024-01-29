# Sorting
## Bubble sort
- Really simple
- Quadratic time complexity
- Compare element `i` with element `i+1`, and swap if it is greater. This pushes maximum element to the final index. Shrink working array to not include maximum element and repeat. After each iteration the next largest value is added to the sort sub-array at the end of the target array. 

## Insertion sort
- Also pretty simple
- Quadratic time complexity
- Maintain a sorted sub-array on the left of the target array. Iterate backwards through the sorted sub-array, and insert the element into the correct position. The sorted sub-array is now one element longer. Repeat until the whole target array is sorted.

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
