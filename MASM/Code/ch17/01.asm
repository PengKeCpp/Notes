assume cs:code
code segment
start:
    ;读取键盘缓存区中的字符
    mov ah,0
    int 16H
    ;ah 存储扫描码, al存储ASCII码
    mov ah,1
    cmp al,'r'
    je red
    cmp al,'g'
    je green
    cmp al,'b'
    je blue
    jmp short sret
red:shl ah,1
green:shl ah,1
blue:
    mov dx,0B800H
    mov es,dx
    mov cx,2000
    mov bx,1
s:  and byte ptr es:[bx],11111000B
    or byte ptr es:[bx],ah
    add bx,2
    loop s
sret:
    mov ax,4c00H
    int 21H
code ends
end start