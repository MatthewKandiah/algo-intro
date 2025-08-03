format ELF64 executable 3

entry start

macro print ptr,len {
  mov rax, 1
  mov rdi, 1
  mov rsi, ptr
  mov rdx, len
  syscall
}

macro exit code {
  mov rax, 60
  mov rdi, code
  syscall
}

PROT_READ = 0x1
PROT_WRITE = 0x2
MAP_PRIVATE = 0x2
MAP_ANONYMOUS = 0x20
macro mmap len {
  mov rax, 9
  mov rdi, 0
  mov rsi, len
  mov rdx, PROT_READ or PROT_WRITE
  mov r10, MAP_PRIVATE or MAP_ANONYMOUS
  mov r8, -1
  mov r9, 0
  syscall
}

macro munmap ptr,len {
  mov rax, 11
  mov rdi, ptr
  mov rsi, len
  syscall
}

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
  exit 0

segment readable writable
hello db "Hello, World", 0xa
hello_len = $-hello
