assume cs:code,ds:data,ss:stack
stack segment
    dw 8 dup(8)
stack ends
data segment
    db '1. display      '
    db '2. brows        '
    db '3. replace      '
    db '4. modify       ' 
data ends
code segment
start:
    mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    mov sp,16
    mov cx,4
    mov bx,0
s:  push cx
    mov si,0
    mov cx,4
s0: mov al,[bx+si+3]
    and al,11011111B
    mov [bx+si+3],al
    inc si
    loop s0
    add bx,16
    pop cx
    loop s
    mov ax,4c00H
    int 21H
code ends

end start