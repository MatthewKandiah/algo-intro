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
