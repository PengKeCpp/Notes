assume cs:code,ss:stack
stack segment
    db 16 dup(0)
stack ends
code segment
start:
    mov ax,stack
    mov ss,ax
    mov sp,16
    mov ax,4240H
    mov dx,0FH
    mov cx,0AH
    call divdw
    mov ax,4c00H
    int 21H
divdw:
    push ax
    mov ax,dx
    mov dx,0
    div cx
    mov bx,ax
    pop ax
    push bx
    div cx
    mov cx,dx
    pop dx
    ret
code ends
end start