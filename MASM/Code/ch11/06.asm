assume cs:code,ds:data
data segment
    db 'Welcome to masm!'
    db 16 dup(0)
data ends

code segment
start:
    mov ax,data
    mov ds,ax
    mov es,ax
    mov si,0
    mov di,16
    mov cx,8
    cld
    rep movsw
    mov ax,4c00H
    int 21H
code ends

end start