assume cs:code,ds:data,ss:stack
stack segment
    db 128 dup(0)
stack ends
data segment
    dw 0,0
data ends
code segment
start:
    mov ax,data
    mov ds,ax
    
    mov ax,stack
    mov ss,ax
    mov sp,128
    ;保存9号中断例程地址值到data段中
    mov ax,0
    mov es,ax

    push es:[4*9]
    pop ds:[0]
    push es:[4*9+2]
    pop ds:[2]

    cli
    mov es:[4*9+2],cs
    mov word ptr es:[4*9],offset int9
    sti

    ;显示字符a-z
    mov ax,0B800H
    mov es,ax
    mov al,'a'
s:  mov es:[160*12+40*2],al
    call delay
    inc al
    cmp al,'z'
    jna s

    ;恢复现场
    mov ax,0
    mov es,ax
    push ds:[2]
    pop es:[4*9+2]
    push ds:[0]
    pop es:[4*9]
    ;退出
    mov ax,4c00H
    int 21H
delay:
    push ax
    push dx
    mov dx,10H
    mov ax,0
s1: sub ax,1
    sbb dx,0
    cmp ax,0
    jne s1
    cmp dx,0
    jne s1
    pop dx
    pop ax
    ret

;模拟int9中断例程
int9:
    ;从60端口读取字符
    push ax
    pushf
    in al,60H
    call dword ptr ds:[0]
    cmp al,1
    jne exit
    inc byte ptr es:[160*12+40*2+1]
exit:
    pop ax
    iret
code ends
end start