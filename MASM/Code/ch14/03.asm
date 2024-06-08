;实验14
assume cs:code,ds:table,ss:stack
table segment
    addr db 9,8,7,4,2,0
    strs db '00/00/00 00:00:00'
table ends
stack segment
    db 16 dup(0)
stack ends
code segment
start:
    mov ax,stack
    mov ss,ax
    mov sp,16
    mov ax,table
    mov ds,ax
    mov si,0
    mov di,0
    mov cx,6
    s:
    push cx
    mov al,addr[si]
    out 70H,al
    in al,71H
    mov ah,al
    ;将BCD码转化为ASCII码
    mov cl,4
    shr ah,cl
    and al,0FH

    add ah,30H
    add al,30H
    mov strs[di],ah
    mov strs[di+1],al
    add si,1
    add di,3
    pop cx
    loop s

    mov ax,0B800H
    mov es,ax
    mov cx,17
    mov si,0
    mov di,0
s0: mov al,strs[si]
    mov es:[160*12+30*2+di],al
    mov byte ptr es:[160*12+30*2+di+1],02H
    add si,1
    add di,2
    loop s0
    mov ax,4c00H
    int 21H
code ends
end start
