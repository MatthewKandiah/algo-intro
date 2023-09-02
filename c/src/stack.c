#include "../include/stack.h"
#include <stdint.h>
#include <stdlib.h>

stack stack_init(uint32_t size) {
  stack result;
  result.data = malloc(size * sizeof(uint32_t));
  result.head = 0;
  result.size = size;
  return result;
}

void stack_deinit(stack s) {
  free(s.data);
}

uint8_t stack_full(stack s) {
  return s.head == s.size;
}

uint8_t stack_empty(stack s) {
  return s.head == 0;
}

// assumes user will check viability with `stack_full` before calling
void stack_push(stack* s, int32_t value) {
  s->data[s->head] = value;
  s->head++;
}

// assumes user will check viability with `stack_empty` before calling
int32_t stack_pop(stack* s) {
  s->head--;
  return s->data[s->head];
}

