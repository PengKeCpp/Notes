;安装将全是字母，以0结尾的字符串，转化为大写
assume cs:code
code segment
    ;设置ds:si 和 es:di指向安装中断例程
start:
    mov dx,cs
    mov ds,dx
    mov si,offset lp
    mov dx,0
    mov es,dx
    mov di,200H
    cld
    mov cx,offset lpend - offset lp
    rep movsb
    ;改变cs和ip的值
    mov word ptr es:[7cH*4],200H
    mov word ptr es:[7cH*4+2],0
    mov ax,4c00H
    int 21H
lp: dec cx
    push bp
    mov bp,sp
    jcxz rt
    add [bp+2],bx
rt:
    pop bp
    iret
lpend:nop
code ends
end start