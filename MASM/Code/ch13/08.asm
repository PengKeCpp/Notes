;bios 中断例程, int 10H 中断例程是bios提供的中断例程，使用ah传递内部子程序的编号
assume cs:code
code segment
start:
    mov ah,2        ;置光标
    mov bh,0        ;第0页
    mov dh,5        ;dh中存储行号
    mov dl,12       ;dl中存放列号
    int 10H

    mov ah,9        ;在光标位置显示字符
    mov al,'a'      ;字符
    mov bl,11001010b;颜色属性
    mov bh,0        ;第0页
    mov cx,3        ;字符重复个数
    int 10H
    
    mov ax,4c00H
    int 21H
code ends

end start