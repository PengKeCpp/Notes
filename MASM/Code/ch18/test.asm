assume cs:code,ds:data
data segment
    list db 9,8
    show_list db 9,8,7,4,2,0
data ends
code segment
start:
    call init_reg
    call change_time
    call show_time
    mov ax,4c00H
    int 21H
init_reg:
    mov ax,data
    mov ds,ax
    mov ax,0B800H
    mov es,ax
    mov di,160*4
ret

change_time:
    mov si,offset list
    mov al,ds:[si]
    out 70H,al
    mov al,22H
    out 71H,al
    mov al,ds:[si+1]
    out 70H,al
    mov al,33H
    out 71H,al
ret

show_time:
    push si
    push cx
    push ax
    mov si,offset show_list
    mov di,160*5+30*2
    mov cx,6
show_tm:
    mov al,ds:[si]
    out 70H,al
    in al,71H
    mov ah,al
    push cx
    mov cl,4
    shr ah,cl
    add ah,30H
    and al,0FH
    add al,30H
    mov es:[di],ah
    mov es:[di+2],al

    pop cx
    inc si
    add di,4
    loop show_tm
    pop ax
    pop cx
    pop si
ret
code ends
end start