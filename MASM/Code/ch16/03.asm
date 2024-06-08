assume cs:code,ss:stack
stack segment
    db 16 dup(0)
stack ends
code segment
start:
    mov ax,stack
    mov ss,ax
    mov sp,16
    mov ax,30
    push ax
    cmp ax,0
    jb exit
    cmp ax,180
    ja exit
    mov bl,30
    div bl
    cmp ah,0
    jne exit
    pop ax
    call showsin
exit:
    mov ax,4c00H
    int 21H
showsin:
    jmp short show
    table dw ag0,ag30,ag60,ag90,ag120,ag150,ag180
    ag0   db '0',0
    ag30  db '0.5',0
    ag60  db '0.866',0
    ag90  db '1',0
    ag120 db '0.866',0
    ag150 db '0.5',0
    ag180 db '0',0
show:
    ;初始化
    push bx
    push es
    push si
    mov bx,0B800H
    mov es,bx
    ;计算ax的角度/30的值,商放在al中
    mov bl,30
    div bl
    mov bl,al
    mov bh,0
    add bx,bx
    ;能使用取地址的寄存器只有:bx,si,di,bp
    mov bx,table[bx]
    mov si,12*160+35*2
shows:
    mov al,cs:[bx]
    cmp al,0
    je showret
    mov es:[si],al
    mov byte ptr es:[si+1],02H
    add si,2
    inc bx
    loop shows
showret:
    pop si
    pop es
    pop bx
    ret
code ends
end start