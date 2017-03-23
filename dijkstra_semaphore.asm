global proberen
global verhogen

%macro align 0
  sub rsp, 8
%endmacro

%macro return 0
  add rsp, 8
  ret
%endmacro

section .text

proberen:
  ; Align stack
  align
  jmp proberen_loop

spin:
  ; Increase semaphore to compensate for the illegal decrease we made before
  lock inc dword [edi]

proberen_loop:
  ; Wait until semaphore is greater than 0
  cmp dword [edi], 0
  jle proberen_loop

  ; Decrease semaphore by one
  mov esi, -1
  lock xadd [edi], esi

  ; Spin if semaphore was not greater than 0
  cmp esi, 0
  jle spin

  ; Return with stack alignment
  return

verhogen:
  ; Align stack
  align
  ; Increase semaphore by one
  lock inc dword [edi]
  ; Return with stack alignment
  return
