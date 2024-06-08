assume cs:codesg
codesg segment
    mov ax,20H
    mov ds,ax
    
    mov al,0
    mov bx,0
    mov cx,64
s:  mov [bx],al
    inc al
    inc bx
    loop s
    mov ax,4c00H
    int 21H

codesg ends
end