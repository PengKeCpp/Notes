;调用7ch中断例程, 将data段中字符串变成大写
assume cs:code,ds:data
data segment
    db 'conversation',0
data ends
code segment
start:
    mov ax,data
    mov ds,ax
    mov si,0
    int 7cH
    mov ax,4c00H
    int 21H
code ends
end start