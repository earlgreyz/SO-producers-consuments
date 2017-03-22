#ifndef PRODUCER_CONSUMER_H
#define PRODUCER_CONSUMER_H

#include <stddef.h>
#include <stdint.h>

int init(size_t N);
void deinit(void);
void producer(void);
void consumer(void);

int produce(int64_t * P);
int consume(int64_t P);

#endif //PRODUCER_CONSUMER_H
