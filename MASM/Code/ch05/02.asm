assume cs:codesg

codesg segment
    mov ax,0FFFFH
    mov ds,ax
    mov dx,0
    mov cx,3
s:  mov ax,ds:[6]
    mov ah,0
    add dx,ax
    loop s
    mov ax,4c00H
    int 21H
codesg ends
end