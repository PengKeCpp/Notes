;dos 中断例程应用
;int 21H 是dos提供的中断例程
assume cs:code,ds:data
data segment
    db 'Welcome to masm','$'
data ends
code segment
start:
    mov ah,2        ;置光标
    mov bh,2        ;第0页
    mov dh,5        ;dh存放行号
    mov dl,12       ;dl中存放列好
    int 10H

    mov ax,data
    mov ds,ax       ;第0页
    mov dx,0
    mov ah,9        ;表示要调用21H号的中断例程的9号子程序
    int 21H
    mov ax,4c00H
    int 21H
code ends
end start