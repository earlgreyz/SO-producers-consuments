global init
global deinit
global producer
global consumer

extern malloc, free

INIT_SUCCESS      equ 0
INIT_OVERFLOW_ERR equ -1
INIT_EMPTY_ERR    equ -2
INIT_ALLOC_ERR    equ -3

SIZE_T_MAX        equ 2147483647

section .bss
  buffer: resb 8

section .text
  ; Init function errors
  init_overflow_err:
    mov rax, INIT_OVERFLOW_ERR
    ret

  init_empty_err:
    mov rax, INIT_EMPTY_ERR
    ret

  init_alloc_err:
    mov rax, INIT_ALLOC_ERR
    ret

  ; Init
  init:
    cmp rdi, SIZE_T_MAX
    jg init_overflow_err

    test rdi, rdi
    jz init_empty_err

    shl rdi, 3
    call malloc

    test rax, rax
    jz init_alloc_err

    mov [buffer], rax

  init_success:
    mov rax, INIT_SUCCESS
    ret

  ; Finish
  deinit:
    mov rdi, [buffer]
    call free
    ret

  ; Producer
  producer:
    ret

  ; Consumer
  consumer:
    ret
