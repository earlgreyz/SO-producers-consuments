global init
global deinit
global producer
global consumer

extern malloc, free
extern proberen, verhogen
extern produce, consume

; Return codes
SUCCESS             equ 0
INIT_OVERFLOW_ERR   equ -1
INIT_EMPTY_ERR      equ -2
INIT_ALLOC_ERR      equ -3

; Constants
SIZE_T_MAX          equ 2147483647 ; (2 << 31) -1

; Returns given `error_code`
; @param error_code error code to return
%macro return 1
  mov rax, %1
  ret
%endmacro

; Performs `value = (value + 1) % base`
; @param value
; @param base
%macro inc_mod 2
  mov rax, %1
  inc rax
  xor edx, edx

  mov rsi, %2
  div rsi

  mov %1, rdx
%endmacro

section .data
  format: db "%ld", 0x0a, 0

section .bss
  buffer: resq 1
  buffer_size: resq 1

  producers_sem: resd 1
  consumers_sem: resd 1

  producer_portion: resq 1
  producer_index: resq 1

  consumer_portion: resq 1
  consumer_index: resq 1

section .text
  ; @returns `SUCCESS`
  success:
    return SUCCESS

  ; @returns `INIT_OVERFLOW_ERR`
  init_overflow_err:
    return INIT_OVERFLOW_ERR

  ; @returns `INIT_EMPTY_ERR`
  init_empty_err:
    return INIT_EMPTY_ERR

  ; @returns `INIT_ALLOC_ERR`
  init_alloc_err:
    return INIT_ALLOC_ERR

  ; `int init(size_t n)`
  ; Allocates array of `int64_t` and semaphores.
  ; @param n array length
  ; @returns error_code:
  ; * 0, when success
  ; * -1, when `N` > 2^31 - 1;
  ; * -2, when `N` = 0;
  ; * -3, when memory allocation fails
  init:
    ; Save buffer size
    mov [buffer_size], rdi

    ; Check for overload
    cmp rdi, SIZE_T_MAX
    jg init_overflow_err

    ; Check for n = 0
    test rdi, rdi
    jz init_empty_err

    ; Allocate memory
    push rdi
    sal rdi, 3
    call malloc
    pop rdi

    ; Check for memory allocation failure
    test rax, rax
    jz init_alloc_err

    ; Save allocated memory pointer to buffer
    mov [buffer], rax

    ; Initialize semaphores
    mov [producers_sem], rdi
    mov qword [consumers_sem], 0

    jmp success

  ; `void deinit(void)`
  ; Frees array allocated with `init`
  deinit:
    mov rdi, [buffer]
    call free
    jmp success

  producer:
    ; Push register for later cleanup
    push rdi
    push rsi

    ; Current buffer index
    mov qword [producer_index], 0

  producer_loop:
    ; Produce portion and store it in portion variable
    mov qword rdi, producer_portion
    call produce

    ; Check if no portion has been produced and we should finish
    test rax, rax
    jz producer_end

    ; Try to aquire producers semaphore
    mov edi, producers_sem
    call proberen

    ; rax = pointer to `buffer[0]`
    mov rax, [buffer]
    ; rcx = index * sizeof(int64_t)
    mov rcx, [producer_index]
    sal rcx, 3
    ; rax = pointer to `buffer[producer_index]`
    add rax, rcx
    ; Insert portion into the buffer
    mov qword rcx, [producer_portion]
    mov [rax], rcx

    ; Increase consumers semaphore
    mov edi, consumers_sem
    call verhogen

    ; Increase index by one modulo buffer_size
    inc_mod [producer_index], [buffer_size]

    jmp producer_loop

  producer_end:
    pop rsi
    pop rdi
    ret

  consumer:
    ; Push register for later cleanup
    push rdi
    push rsi

    ; Current buffer index
    mov qword [consumer_index], 0

  consumer_loop:
    ; Try to aquire consumers semaphore
    mov edi, consumers_sem
    call proberen

    ; Get portion at consumer_index
    mov rax, [buffer]
    ; rcx = index * sizeof(int64_t)
    mov rcx, [consumer_index]
    sal rcx, 3
    ; rax = pointer to `buffer[consumer_index]`
    add rax, rcx
    ; Insert portion into the buffer
    mov qword rcx, [rax]

    mov [consumer_portion], rcx

    ; Increase producers semaphore
    mov edi, producers_sem
    call verhogen

    ; Increase index by one modulo buffer_size
    inc_mod [consumer_index], [buffer_size]

    ; Consume portion
    mov rdi, [consumer_portion]
    call consume

    ; Check if the portion is the last one
    test rax, rax
    jz consumer_end

    jmp consumer_loop

  consumer_end:
    pop rsi
    pop rdi
    ret
