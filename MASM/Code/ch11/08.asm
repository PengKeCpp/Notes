assume cs:code
code segment
start:
    mov ax,0
    push ax
    popf
    mov ax,0FFF0H
    add ax,0010h
    pushf
    pop ax
    and al,11000101B
    and ah,00001000B
    mov ax,4c00H
    int 21H
code ends

end