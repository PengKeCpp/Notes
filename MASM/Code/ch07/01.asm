assume cs:code,ds:data
data segment
    db 'BaSiC'
    db 'iNForMaTiOn'
data ends

code segment
start:
    mov ax,data
    mov ds,ax
    mov cx,5
    mov bx,0
s:  mov al,[bx]
    and al,11011111B
    mov [bx],al
    inc bx
    loop s
    mov cx,11
    add bx,5
s0: mov al,[bx]
    or al,00100000B
    mov [bx],al
    inc bx
    loop s0
    mov ax,4c00H
    int 21H
code ends
end start