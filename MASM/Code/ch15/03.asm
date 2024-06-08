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
    ;安装int9中断过程
    push cs
    pop ds
    mov si,offset int9start
    mov ax,0
    mov es,ax
    mov di,204H
    mov cx,offset int9end-offset int9start
    rep movsb
    ;保存现有int9的中断处理程序地址
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
    jmp short begin
    db 0
begin:
    push ax
    push bx
    push cx
    push es
    in al,60H
    mov bx,0
    mov es,bx
    pushf
    call dword ptr es:[200H]
    mov ah,es:[206H]
    mov es:[206H],al
    cmp ah,1EH
    jne int9exit
    cmp al,1EH+80H
    jne int9exit
    mov ax,0B800H
    mov es,ax
    mov cx,2000
    mov bx,0
    s:
    mov byte ptr es:[bx],'A'
    add bx,2
    loop s

int9exit:
    pop es
    pop cx
    pop bx
    pop ax
    iret
int9end:nop
code ends
end start