format ELF64 executable 3

entry start

segment readable executable
start:
  mov rax, 1
  mov rdi, 1
  mov rsi, hello
  mov rdx, hello_len
  syscall

  mov rax, 60
  mov rdi, 0
  syscall

segment readable writable
hello db "Hello, World", 0xa
hello_len = $-hello
