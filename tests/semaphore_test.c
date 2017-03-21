#include "../dijkstra_semaphore.h"
#include <stdio.h>
#include <assert.h>

int32_t semaphore = 1;

int main() {
    proberen(&semaphore);
    assert(semaphore == 0);
    return 0;
}
