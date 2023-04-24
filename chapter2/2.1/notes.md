# Insertion sort
An efficient algorithm for sorting a small number of elements

```
for i = 2 to n // for each element, starting with the second
  key = A[i]
  j = i - 1 // start with the previous element
  while j > 0 and A[j] > key // if A[j] is a valid element and greater than key
    A[j + 1] = A[j] // move this element forward in the list
    j = j - 1 // and look at the previous element
  A[j + 1] = key // insert key into its correct location
```

## Loop invariants and demonstrating algorthm correctness
- i : current element index
- A[1 : i-1] : the subarray consisting of contiguous elements A[1] to A[i-1]
- A[1: i-1] are the elements originally in positions 1 to i-1, but now in their sorted order. This is a loop invariant property.

