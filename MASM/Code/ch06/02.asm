assume cs:codesg
codesg segment
    dw 0123H,0456H,0789H,0abcH,0defH,0fedH,0cbaH,0987H
    dw 0,0,0,0,0,0,0,0,0,0
start:
    mov ax,cs
    mov ss,ax
    mov sp,1BH
    mov ax,0
    mov ds,ax
    mov bx,0
    mov cx,8
s:  push [bx]
    pop cs:[bx]
    add bx,2
    loop s
    mov ax,4c00H
    int 21H
codesg ends
end start