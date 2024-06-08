assume cs:codesg
codesg segment
    mov cx,11
    mov bx,0

s:  mov ax,0FFFFH
    mov ds,ax
    mov dl,[bx]
    
    mov ax,20H
    mov ds,ax
    mov [bx],dl
    inc bx
    loop s
    
    mov ax,4c00H
    int 21H
codesg ends
end