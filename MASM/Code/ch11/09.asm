;实验11
assume cs:codesg

datasg segment
    db "Beginner's All-purpose Symbolic Instruction Code.",0
datasg ends

codesg segment
start:
    mov ax,datasg
    mov ds,ax
    mov si,0
    call letterc
    mov ax,4c00H
    int 21H
letterc:
s:  cmp byte ptr [si],0
    je rt
    cmp byte ptr [si],97
    jna next
    cmp byte ptr [si],122
    jnb next
    and byte ptr [si],11011111B
next:
    inc si
    loop s
rt:
    ret
codesg ends
end start