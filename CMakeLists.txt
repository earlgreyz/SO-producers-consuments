cmake_minimum_required(VERSION 3.6)
project(SO_producers_consuments)

set(CMAKE_C_STANDARD 99)

set(SOURCE_FILES dijkstra_semaphore.h producer_consumer.h)
add_executable(SO_simple_test tests/simple_test.c ${SOURCE_FILES})