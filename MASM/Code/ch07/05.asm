assume cs:code,ds:data
data segment
    db 'ibm             '
    db 'dec             '
    db 'dos             '
    db 'vax             '
    dw 0
data ends

code segment
start:
    mov ax,data
    mov ds,ax
    mov bx,0
    mov cx,4
s:  mov si,0
    mov ds:[40H],cx
    mov cx,3
s0: mov al,[bx+si]
    and al,11011111B
    mov [bx+si],al
    inc si
    loop s0
    mov cx,ds:[40H]
    add bx,16
    loop s
    mov ax,4c00H
    int 21H
code ends
end start