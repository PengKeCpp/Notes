assume cs:code,ss:stack,ds:data
stack segment
    db 16 dup(0)
stack ends
data segment
    db 15 dup(0),2
    db 15 dup(0),33
data ends
code segment
start:
    mov ax,stack
    mov ss,ax
    mov sp,16
    mov ax,data
    mov ds,ax
    mov si,0
    mov di,16
    call int128
    mov ax,4c00H
    int 21H
int128:
    push ax
    push cx
    push si
    push di
    sub ax,ax   ;将CF置为0
    mov cx,8
s:  mov ax,ds:[si]
    adc ax,ds:[di]
    mov ds:[si],ax
    inc si
    inc si
    inc di
    inc di
    loop s

    pop di
    pop si
    pop cx
    pop ax
    ret
code ends

end start