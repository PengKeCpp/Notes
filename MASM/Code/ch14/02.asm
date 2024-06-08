;访问cmos ram中存储的月份进行显示
assume cs:code
code segment
start:
    ;从端口中读取地址8的值
    mov al,8
    out 70h,al
    in al,71h

    ;将读出来的BCD码分离到两个寄存器上
    mov ah,al
    mov cl,4
    shr ah,cl
    and al,0FH
    
    ;将BCD码值加30H为对应的ASCII值
    add al,30h
    add ah,30h
    mov dx,0B800H
    mov es,dx
    mov si,160*12+40*2
    mov es:[si],ah
    mov byte ptr es:[si+1],02H
    mov es:[si+2],al
    mov byte ptr es:[si+3],02H
    mov ax,4c00H
    int 21H
code ends
end start