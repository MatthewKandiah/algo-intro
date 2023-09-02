#include <stdint.h>
typedef struct {
  // pointer to start of backing array
  int32_t *data;
  // index of top of the stack => next position where a value will be added
  uint32_t head;
  // size of backing array
  uint32_t size;
} stack;

stack stack_init(uint32_t size);
void stack_deinit(stack s);
uint8_t stack_full(stack s);
uint8_t stack_empty(stack s);
void stack_push(stack *s, int32_t value);
int32_t stack_pop(stack *s);
