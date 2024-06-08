;安装中断处理程序
assume cs:code
code segment
start:
    mov ax,cs
    mov ds,ax
    mov si,offset do0start
    mov ax,0
    mov es,ax
    mov di,200H
    mov cx,offset do0end - offset do0start
    cld
    rep movsb
    mov ax,0
    mov es,ax
    mov word ptr es:[0],200H
    mov word ptr es:[2],0
    mov ax,4c00H
    int 21H
do0start:
    jmp short run
    strs db 'overflow!!'
run:
    mov ax,0
    mov ds,ax
    mov si,202H
    mov ax,0B800H
    mov es,ax
    mov di,160*12+35*2
    mov cx,10
s:  mov al,ds:[si]
    mov es:[di],al
    mov byte ptr es:[di+1],02H
    add si,1
    add di,2
    loop s
    mov ax,4c00H
    int 21H
do0end:
    nop
code ends
end start