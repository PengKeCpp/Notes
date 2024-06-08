;安装7ch执行乘法
assume cs:code
code segment
    ;设置ds:si 和 es:di指向安装中断例程
start:
    mov dx,cs
    mov ds,dx
    mov si,offset sqr
    mov dx,0
    mov es,dx
    mov di,200H
    mov cx,offset sqrend - offset 
    cld
    rep movsb
    ;改变cs和ip的值
    mov word ptr es:[7cH*4],200H
    mov word ptr es:[7cH*4+2],0
    
    mov ax,4c00H
    int 21H
sqr:
    mul ax
    iret
sqrend:nop
code ends
end start