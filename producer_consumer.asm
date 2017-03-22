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
; @param error_code Error code to return
; @returns `error_code`
%macro return 1
  mov rax, %1
  ret
%endmacro

section .bss
  buffer: resq 1
  producers_sem: resd 1
  consumers_sem: resd 1

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
    ; Check for overload
    cmp rdi, SIZE_T_MAX
    jg init_overflow_err

    ; Check for n = 0
    test rdi, rdi
    jz init_empty_err

    ; Allocate memory
    push rdi
    shl rdi, 3
    call malloc
    pop rdi

    ; Check for memory allocation failure
    test rax, rax
    jz init_alloc_err

    ; Save allocated memory pointer to buffer
    mov [buffer], rax

    ; Initialize semaphores
    mov [producers_sem], rdi
    mov word [consumers_sem], 0

    jmp success

  ; `void deinit(void)`
  ; Frees array and semaphores allocated with `init`
  deinit:
    mov rdi, [buffer]
    call free
    jmp success

  ; Producer
  producer:
    ret

  ; Consumer
  consumer:
    ret
