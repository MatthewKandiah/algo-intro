format ELF64 executable 3

entry start

include "./syscalls.inc.asm"
include "./heap.inc.asm"

segment readable executable
start:
  heap_build 24
  mov r14, rax
  mov qword [r14 + 16 + 0], 0x16
  mov qword [r14 + 16 + 8], 0x14
  mov qword [r14 + 16 + 16], 0x15
  mov qword [r14], 3

  push r14
  call is_max_heap
  pop r14

  heap_free r14
  exit 0

segment readable writable
