global proberen
global verhogen

section .text

spin:
  ; Increase semaphore to compensate for the illegal decrease we made before
  lock inc dword [edi]

proberen:
  ; Wait until semaphore is greater than 0
  cmp dword [edi], 0
  jle proberen

  ; Decrease semaphore by one
  mov esi, -1
  lock xadd [edi], esi

  ; Spin if semaphore was not greater than 0
  cmp esi, 0
  jle spin

  ret

verhogen:
  ; Increase semaphore by one
  lock inc dword [edi]
  ret
