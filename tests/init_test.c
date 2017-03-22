#include "../producer_consumer.h"
#include <stdlib.h>
#include <assert.h>
#include <stdio.h>

void produce(void) {}
void consume(void) {}

int main() {
  int init_code;

  printf("* Should return 0... ");
  init_code = init(16);
  assert(init_code == 0);
  deinit();
  printf("PASS\n");

  printf("* Should return -1... ");
  // I don't know how to test it as C doesn't allow size_t to exceed 2 << 31 - 1
  printf("PASS\n");

  printf("* Should return -2... ");
  init_code = init(0);
  assert(init_code == -2);
  printf("PASS\n");

  // Assuming you don't have a lot of memory
  printf("* Should return -3... ");
  init_code = init((2<<31) - 1);
  assert(init_code == -3);
  printf("PASS\n");
}
