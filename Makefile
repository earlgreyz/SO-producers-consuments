TESTS = semaphore_test
CC = gcc
CFLAGS = -Wall -O2

all: $(TESTS)

dijkstra_semaphore.o: dijkstra_semaphore.asm
	nasm -f elf64 -o $@ $<

producer_consumer.o: producer_consumer.asm
	nasm -f elf64 -o $@ $<

semaphore_test.o: tests/semaphore_test.c dijkstra_semaphore.h producer_consumer.h
	$(CC) -c $(CFLAGS) -o $@ $<

semaphore_test: semaphore_test.o dijkstra_semaphore.o producer_consumer.o
	$(CC) -o $@ $^

.PHONY: all clean

clean:
	rm -rf $(TESTS) *.o
