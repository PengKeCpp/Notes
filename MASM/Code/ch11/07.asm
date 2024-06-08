assume cs:code,ds:data
data segment
    db 16 dup(0)
data ends

code segment
start:
    mov ax,0F000H
    mov ds,ax
    mov si,0FFFFH
    mov ax,data
    mov es,ax
    mov di,14
    mov cx,8
    std
    rep movsw
    mov ax,4c00H
    int 21H
code ends

end start