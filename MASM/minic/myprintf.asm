assume cs:code,ds:data,ss:stack
data segment
    db 'This is a %c %d is Test %c',0
data ends
stack segment
    db 128 dup(0)
    top dw 0
stack ends
code segment
start:
    mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    mov sp,128
    mov bp,sp
    mov ax,63H
    push ax
    mov ax,5
    push ax
    mov ax,61H
    push ax
    call myprintf
    mov ax,4c00H
    int 21H
myprintf:
    push bp
    mov bp,sp
    mov ax,0b800H
    mov es,ax
    mov di,160*12+35*2
    mov si,0
    mov top,4
s:
    mov al,ds:[si]
    cmp al,0
    je printf_ret
    cmp al,37
    je show_field
    mov es:[di],al
    add di,2
    inc si
    jmp s
printf_ret:
    pop bp
    ret
show_field:
    mov al,ds:[si+1]
    cmp al,99
    je show_c
    cmp al,100
    je show_d
    jmp far ptr s
show_d:
    mov cx,0        ;记录多少个数字
    push bp
    add bp,top
    mov ax,ss:[bp]
    pop bp
round_num:
    push cx
    mov dx,0
    mov cx,10
    div cx
    cmp ax,0
    jne calc_d
    cmp dx,0
    jne calc_d
    pop cx
    jmp show_nums
show_d_exit:
    add si,2
    add top,2
    jmp far ptr s
show_nums:
    pop ax
    mov es:[di],al
    add di,2
    loop show_nums
    jmp show_d_exit
calc_d:
    pop cx
    add dx,30H
    push dx
    inc cx
    jmp far ptr round_num
show_c:
    push bp
    add bp,top
    mov ax,ss:[bp]
    pop bp
    mov es:[di],al
    add si,2
    add di,2
    add top,2
    jmp far ptr s
code ends
end start