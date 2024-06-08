;使用7cH中断例程实现loop功能，实现在屏幕中间显示!
assume cs:code
code segment
start:
    mov ax,0B800H
    mov ds,ax
    mov si,160*12
    mov bx,offset s - offset se
    mov cx,80
s:  mov byte ptr ds:[si],'!'
    mov byte ptr ds:[si+1],02H
    add si,2
    int 7cH
se: nop
    mov ax,4c00H
    int 21H
code ends
end start