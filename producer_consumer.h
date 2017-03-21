#ifndef PRODUCER_CONSUMER_H
#define PRODUCER_CONSUMER_H

#include <stddef.h>

int init(size_t N);
void deinit(void);
void producer(void);
void consumer(void);

#endif //PRODUCER_CONSUMER_H
