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
  * `-1`, gdy N > 2<sup>31</sup> - 1;
  * `-2`, gdy N = 0;
  * `-3`, gdy alokacja pamięci się nie powiodła.

__Wskazówka:__ przy porównywaniu liczb ze znakiem korzysta się z instrukcji
`je`, `jg`, `jge`, `jl`, `jle`, `jne`, `jng`, `jnge`, `jnl`, `jnle`, a przy
porównywaniu liczb bez znaku – `je`, `ja`, `jae`, `jb`, `jbe`, `jne`, `jna`,
`jnae`, `jnb`, `jnbe`.

__Wskazówka:__ o alokowaniu pamięci w programie asemblerowym można poczytać tu
http://x86asm.net/articles/memory-allocation-in-linux. Program będzie linkowany
ze standardową biblioteką języka C.

__Wskazówka:__ zmienne globalne inicjowane w trakcie wykonywania programu
umieszcza się w sekcji `.bss`.

Funkcja `producer` realizuje protokół producenta. Aby wyprodukować porcję
danych `P`, woła funkcję `produce(&P)` o sygnaturze

```c
int produce(int64_t *);
```   

Funkcja `produce` zwraca __1__, gdy wyprodukowała porcję danych, a __0__, gdy nie
wyprodukowała danych i wtedy funkcja producer powinna się zakończyć.

Funkcja `consumer` realizuje protokół konsumenta. Aby skonsumować porcję
danych P, woła funkcję `consume(P)` o sygnaturze

```c
int consume(int64_t);
```

Funkcja `consume` zwraca __1__, gdy oczekuje kolejnych danych, a __0__, gdy otrzymana
porcja danych jest ostatnią oczekiwaną i wtedy funkcja consumer powinna się
zakończyć.

__Wskazówka:__ w asemblerze identyfikatory wołanych funkcji, które są
zaimplementowane w innych jednostkach translacji, należy zadeklarować jako
`extern`.

__Termin oddania:__ 24 marca 2017, godz. 20.

Pliki należy umieścić w repozytorium SVN w katalogu`studenci/ab123456/zadanie2`,
gdzie `ab123456` jest identyfikatorem studenta używanym do logowania w
laboratorium komputerowym.
