format ELF64 executable 3

entry start

include "./syscalls.inc.asm"
include "./heap.inc.asm"

segment readable executable
start:
  heap_build 24
  mov r14, rax
  mov qword [r14 + 16 + 0], 0x16
  mov qword [r14 + 16 + 8], 0x18
  mov qword [r14 + 16 + 16], 0x17
  mov qword [r14], 3

  push r14
  call is_max_heap
  call assert_false
  call is_min_heap
  call assert_true
  pop r14

  heap_free r14
  print success_msg, success_msg_len
  exit 0

assert_true:
  cmp rax, 1
  jne .fatal
  ret
  .fatal:
    exit 1

assert_false:
  cmp rax, 0
  jne .fatal
  ret
  .fatal:
    exit 1

segment readable writable
success_msg db "Success!", 0xa
success_msg_len = $-success_msg
