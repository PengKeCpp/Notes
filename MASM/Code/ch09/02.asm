assume cs:code,ds:data

data segment
    db 'welcome to masm!'
data ends

code segment
start:
    mov ax,data
    mov ds,ax
    mov ax,0B800H
    mov es,ax
    mov si,0
    mov di,160*12+80-16
    mov cx,16
w:  mov al,[si]
    mov es:[di],al
    inc di
    mov al,71H
    mov es:[di],al
    inc si
    inc di
    loop w

    mov ax,4c00H
    int 21H
code ends

end start 