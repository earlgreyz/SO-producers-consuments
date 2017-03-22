#include "../producer_consumer.h"
#include "../dijkstra_semaphore.h"
#include <stdlib.h>
#include <assert.h>
#include <stdio.h>

#define MAX_COUNT 16

int64_t producer_count = 0;
int64_t consumer_count = 0;
int64_t * get_buffer(void);

int produce(int64_t * P) {
  if (producer_count < MAX_COUNT) {
    *P = ++producer_count;
    return 1;
  } else {
    return 0;
  }
}

int consume(int64_t P) {
  assert(P = consumer_count + 1);
  consumer_count = P;
  if (consumer_count < MAX_COUNT) {
    return 1;
  } else {
    return 0;
  }
}

int main() {
  int init_code;

  printf("Initialization... ");
  init_code = init(16);
  assert(init_code == 0);
  printf("OK.\n");

  printf("Producer... ");
  producer();
  assert(producer_count == MAX_COUNT);
  printf("OK.\n");

  printf("Consumer... ");
  consumer();
  assert(consumer_count == MAX_COUNT);
  printf("OK.\n");

  deinit();
}
