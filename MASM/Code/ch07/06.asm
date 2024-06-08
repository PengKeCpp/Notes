assume cs:code,ds:data,ss:stack

stack segment
    dw 8 dup (0)
stack ends
data segment
    db 'ibm             '
    db 'dec             '
    db 'dos             '
    db 'vax             '
data ends

code segment
start:    
    mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    mov sp,16
    mov cx,5
    mov bx,0
s:  push cx
    mov si,0
    mov cx,3
s0: mov al,[bx+si]
    and al,11011111B
    mov [bx+si],al
    inc si
    loop s0
    add bx,16
    pop cx
    loop s
    mov ax,4c00H
    int 21H
code ends

end start