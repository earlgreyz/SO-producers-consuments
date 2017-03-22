#include "../producer_consumer.h"
#include "../dijkstra_semaphore.h"
#include <stdlib.h>
#include <assert.h>
#include <stdio.h>

#define MAX_COUNT 10

int64_t count = 0;

int produce(int64_t * P) {
  printf("PRODUCE %ld... ", count);
  if (count < MAX_COUNT) {
    *P = count++;
    printf("OK\n");
    return 1;
  } else {
    printf("FAILED\n");
    return 0;
  }
}

int consume(int64_t P) {
  return 0;
}

int main() {
  int init_code;

  init_code = init(16);
  assert(init_code == 0);

  producer();
  assert(count == 10);

  deinit();
}
