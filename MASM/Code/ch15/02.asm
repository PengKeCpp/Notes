assume cs:code,ss:stack
stack segment
    db 128 dup(0)
stack ends
code segment
start:
    ;初始化寄存器
    mov ax,stack
    mov ss,ax
    mov sp,128
    ;将安装int9中断程序例子    
    push cs
    pop ds
    mov si,offset int9start
    mov ax,0
    mov es,ax
    mov di,204H
    mov cx,offset int9end-offset int9start
    cld
    rep movsb

    push es:[4*9]
    pop es:[200H]
    push es:[4*9+2]
    pop es:[202H]
    cli
    mov word ptr es:[4*9],204H
    mov word ptr es:[4*9+2],0H
    sti

    mov ax,4c00H
    int 21H
int9start:
    push ax
    push es
    push cx
    push bx
    in al,60H
    mov bx,0
    mov es,bx
    
    pushf   ;产生中断时：1、获取中断类型码n 2、标志寄存器入栈，IF=0,TF=0 3、push CS push IP 4、(CS)=(4*n+2) (IP)=(4*n) 5、调用中断过程
    call dword ptr es:[200H]
    
    cmp al,3BH
    jne int9exit

    mov ax,0B800H
    mov es,ax
    mov bx,1
    mov cx,2000
    s:inc byte ptr es:[bx]
    add bx,2
    loop s
int9exit:
    pop bx
    pop cx
    pop es
    pop ax
    iret
int9end:nop
code ends
end start