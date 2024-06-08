;使用7cH中断例程实现loop功能，实现在屏幕中间显示conversation 字符串，字符串以0作为结束
assume cs:code,ds:data
data segment
    db 'conversation',0
data ends
code segment
start:
    mov ax,data
    mov ds,ax
    mov si,0
    mov ax,0B800H
    mov es,ax
    mov di,160*12+35*2
    mov bx,offset s - offset ok
s:  cmp byte ptr ds:[si],0
    je ok
    mov cl,ds:[si]
    mov es:[di],cl
    mov byte ptr es:[di+1],02H
    inc si
    add di,2
    int 7cH
ok:
    mov ax,4c00H
    int 21H
code ends
end start