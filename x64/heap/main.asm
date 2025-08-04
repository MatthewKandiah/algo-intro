format ELF64 executable 3

entry start

include "./syscalls.inc.asm"
include "./heap.inc.asm"

segment readable executable
start:
  print hello, hello_len

  ;; allocate a new block of memory, copy data into it, and print it
  mmap hello_len
  mov r15, rax ;; pointer to copied data
  mov r14, 0 ;; counter
  mov r13, r15 ;; copy dest address
  mov r12, hello ;; copy source address
  .loop_start:
    mov r11b, byte[r12]
    mov byte [r13], r11b
    inc r14
    add r13, 1
    add r12, 1
    cmp r14, hello_len
    jl .loop_start

  print r15, hello_len
  munmap r15, hello_len

  heap_build 24
  heap_set_data rax,8,0xffffffffffffffff
  exit 0

segment readable writable
hello db "Hello, World", NEWLINE
hello_len = $-hello
