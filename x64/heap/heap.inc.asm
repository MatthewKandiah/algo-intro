;; HEAP
;; memory layout (X: byte displacement from heap ptr, description of field)
;; 0: heap_size (qword) = number of elements currently in heap
;; 8: capacity (qword) = max number of elements that can be stored in heap
;; 16: data = ptr to first element, elements assumed to be qword sized

;; all field access macros move desired value into rax

macro heap_size ptr {
	mov rax, qword [ptr]
}

macro heap_capacity ptr {
	mov rax, qword [ptr + 8]
}

macro heap_data ptr {
	mov rax, qword [ptr + 16]
}

macro heap_set_size ptr,value {
	mov qword [ptr], value
}

macro heap_set_capacity ptr,value {
	mov qword [ptr + 8], value
}

macro heap_set_data ptr,index,value {
	mov qword [ptr+16+index*8], value
}

macro heap_build cap {
	mmap cap+16
	heap_set_size rax, 0
	heap_set_capacity rax, cap
}

macro heap_free ptr {
	heap_capacity ptr
	mov r15, rax
	munmap ptr, r15
}
