STDOUT = 1
NEWLINE = 0xa
macro print ptr,len {
  mov rax, 1
  mov rdi, STDOUT
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

