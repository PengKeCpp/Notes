assume cs:code

code segment
start:
    mov ax,0
    sub al,al
    mov al,10H
    add al,90H
    mov al,80H
    add al,80H
    mov al,0FCH
    add al,05H
    mov al,7DH
    add al,0BH
    mov ax,4C00H
    int 21H
code ends

end start