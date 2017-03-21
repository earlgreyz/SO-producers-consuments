TESTS = semaphore_test advanced_semaphore_test
CC = gcc
CFLAGS = -Wall -O2

all: $(TESTS)

dijkstra_semaphore.o: dijkstra_semaphore.asm
	nasm -f elf64 -o $@ $<

producer_consumer.o: producer_consumer.asm
	nasm -f elf64 -o $@ $<

err.o: tests/err.c
	$(CC) -c $(CFLAGS) -o $@ $<

semaphore_test.o: tests/semaphore_test.c dijkstra_semaphore.h
	$(CC) -c $(CFLAGS) -o $@ $<

semaphore_test: semaphore_test.o dijkstra_semaphore.o
	$(CC) -o $@ $^

advanced_semaphore_test.o: tests/advanced_semaphore_test.c tests/err.h
	$(CC) -c $(CFLAGS) -o $@ $<

advanced_semaphore_test: advanced_semaphore_test.o err.o dijkstra_semaphore.o
	$(CC) -o $@ $^ -lpthread -pthread

.PHONY: all clean

clean:
	rm -rf $(TESTS) *.o
