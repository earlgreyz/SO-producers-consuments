# Systemy Operacyjne

## Zadanie 2

Zaimplementuj w __asemblerze x86-64__ rozwiązanie _(z drobnymi modyfikacjami)_ 
zadania o __producencie i konsumencie z buforem cyklicznym__ omawianego na 
ćwiczeniach z PW. Wszystkie implementowane procedury powinny przestrzegać 
konwencji wołania funkcji w języku C. Rozwiązanie powinno składać się z dwóch 
plików.

### Plik `dijkstra_semaphore.asm`

Plik `dijkstra_semaphore.asm` ma zawierać implementację semafora według
klasycznej definicji Dijkstry. Semafor S jest zmienną typu `int32_t` i można na 
nim wykonywać dwie operacje: `proberen(&S)` i `verhogen(&S)`. Plik ten ma
udostępniać te operacje jako dwie funkcje, które mają w C sygnatury:

```c
void proberen(int32_t *);
void verhogen(int32_t *);
```

__Wskazówka:__ użyj instrukcji xadd.

### Plik `producer_consumer.asm`

Plik `producer_consumer.asm` ma udostępniać trzy funkcje:

```c
int init(size_t N);
void producer(void);
void consumer(void);
```
                                                                                
Funkcja `init` alokuje bufor cykliczny dla N porcji danych typu `int64_t` oraz
inicjuje semafory. Zwraca:

  * `0`, gdy sukces;
  * `-1`, gdy N > 2^{31} - 1;
  * `-2`, gdy N = 0;
  * `-3`, gdy alokacja pamięci się nie powiodła.

__Wskazówka:__ przy porównywaniu liczb ze znakiem korzysta się z instrukcji
`je`, `jg`, `jge`, `jl`, `jle`, `jne`, `jng`, `jnge`, `jnl`, `jnle`, a przy 
porównywaniu liczb bez znaku – `je`, `ja`, `jae`, `jb`, `jbe`, `jne`, `jna`,
`jnae`, `jnb`, `jnbe`.
                                                                                
__Wskazówka:__ o alokowaniu pamięci w programie asemblerowym można poczytać tu
http://x86asm.net/articles/memory-allocation-in-linux. Program będzie linkowany
ze standardową biblioteką języka C.