;; HEAP
;; memory layout (X: byte displacement from heap ptr, description of field)
;; 0: heap_size (qword) = number of elements currently in heap
;; 8: capacity (qword) = max number of elements that can be stored in heap
;; 16: data = ptr to first element, elements assumed to be qword sized

macro heap_build cap {
	mmap cap+16
	mov qword [rax], 0
	mov qword [rax + 8], cap
}

macro heap_free ptr {
	mov r15, qword [ptr + 8]
	add r15, 16
	munmap ptr, r15
}

;; heap_index macros expect the index to be on the stack
;; they pop that value, then push the result on to the stack
macro heap_index_parent {
	pop r15
	inc r15
	shr r15, 1
	dec r15
	push r15
}

macro heap_index_left {
	pop r15
	inc r15
	shl r15, 1
	dec r15
	push r15
}

macro heap_index_right {
	pop r15
	inc r15
 	shl r15, 1
	push r15
}

;; expects heap and index to be on the stack
;; returns in rax: 0 for false, 1 for true
;; internals
;; parent index: r8
;; heap ptr: rbp
;; parent element data address: r15
;; child index to compare to: r9
;; child element data: r14
max_heap_node_check:
  mov r8, qword [rsp + 8]
  mov rbp, qword [rsp + 16]
  mov r15, rbp
  add r15, 16
  mov r14, r8
  shl r14, 3
  add r15, r14 ;; [rbp + 16 + 8 * r8]
  .check_left:
    push r15
    push r8
    heap_index_left
    pop r9 ;; left index
    pop r15
    cmp r9, qword [rbp] ;; compare left index with number of elements
    jae .return_true
    ;; compare the value at [rbp + 16 + 8 * r8] and at [rbp + 16 + 8 * r9]
    mov r14, rbp
    add r14, 16
    mov r13, r9
    shl r13, 3
    add r14, r13 ;; rbp + 16 + 8 * r9
    mov r14, qword [r14]
    cmp qword [r15], r14
    jb .return_false
  .check_right:
    push r15
    push r8
    heap_index_right
    pop r9 ;; right index
    pop r15
    cmp r9, qword [rbp] ;; compare right index with number of elements
    jae .return_true
    ;; compare the value at [rbp + 16 + 8 * r8] and at [rbp + 16 + 8 * r9]
    mov r14, rbp
    add r14, 16
    mov r13, r9
    shl r13, 3
    add r14, r13 ;; rbp + 16 + 8 * r9
    mov r14, qword [r14]
    cmp qword [r15], r14
    jb .return_false
  .return_true:
    mov rax, 1
    ret
  .return_false:
    int3
    mov rax, 0
    ret

