global proberen
global verhogen

section .text

spin:
  lock inc dword [edi]
proberen:
  mov esi, -1
  lock xadd [edi], esi
  cmp esi, 1
  jl spin
  ret

verhogen:
  lock inc dword [edi]
  ret
