assume cs:code
code segment
start:
    mov al,0FFH
    call showbyte
    mov ax,4c00H
    int 21H
showbyte:
    jmp short show
    table db '0123456789ABCDEF'         ;字符表
show:
    push bx
    push es
    mov ah,al
    mov cl,4
    shr ah,cl
    and al,0FH

    mov dx,0B800H
    mov es,dx
    mov bl,al
    mov bh,0
    mov al,table[bx]
    mov es:[12*160+40*2],al
    mov byte ptr es:[12*160+40*2+1],02H
    mov bl,ah
    mov bh,0
    mov ah,table[bx]
    mov es:[12*160+40*2+2],ah
    mov byte ptr es:[12*160+40*2+3],02H
    
    pop es
    pop bx
    ret
code ends
end start