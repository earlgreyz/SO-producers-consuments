#include "../dijkstra_semaphore.h"
#include <stdlib.h>
#include <assert.h>
#include <stdio.h>

int produce(int64_t * P) {
  return 0;
}

int consume(int64_t P) {
  return 0;
}

int init(uint64_t size);
void producer(void);
void consumer(void);
void deinit(void);


int main() {
  int init_code;

  printf("* Should return 0... ");
  init_code = init(16);
  assert(init_code == 0);
  deinit();
  printf("PASS\n");

  printf("* Should return -1... ");
  init_code = init(2147483648);
  assert(init_code == -1);
  printf("PASS\n");

  printf("* Should return -2... ");
  init_code = init(0);
  assert(init_code == -2);
  printf("PASS\n");

  // Assuming you don't have a lot of memory
  printf("* Should return -3... ");
  uint64_t size = (2u << 30) - 1;
  init_code = init(size);
  assert(init_code == -3);
  printf("PASS\n");
}
