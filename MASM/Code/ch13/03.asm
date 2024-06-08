;安装将全是字母，以0结尾的字符串，转化为大写
assume cs:code
code segment
    ;设置ds:si 和 es:di指向安装中断例程
start:
    mov dx,cs
    mov ds,dx
    mov si,offset capital
    mov dx,0
    mov es,dx
    mov di,200H
    cld
    mov cx,offset capitalend - offset capital
    rep movsb
    ;改变cs和ip的值
    mov word ptr es:[7cH*4],200H
    mov word ptr es:[7cH*4+2],0
    mov ax,4c00H
    int 21H
capital:
    push si
    push cx
s:
    mov cl,ds:[si]
    mov ch,0
    jcxz rt
    and cl,11011111B
    mov ds:[si],cl
    inc si
    loop s
rt:
    pop cx
    pop si
    iret
capitalend:nop
code ends
end start