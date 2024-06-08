assume cs:code,ss:stack
stack segment
    db 16 dup(0)
stack ends
code segment
start:
    mov ax,stack
    mov ss,ax
    mov sp,16
    call setscreen
    mov ax,4c00H
    int 21H
setscreen:
    jmp short run
    func dw sub1,sub2,sub3,sub4
run:
    push bx
    mov al,2
    mov ah,3
    cmp ah,3
    ja sret
    mov bl,ah
    mov bh,0
    add bx,bx
    call word ptr func[bx]
sret:
    pop bx
    ret
;1、清屏
sub1:
    push es
    push bx
    push cx
    mov bx,0B800H
    mov es,bx
    mov cx,2000
    mov bx,0
sub1s:
    mov byte ptr es:[bx],' '
    add bx,2
    loop sub1s
    pop cx
    pop bx
    pop es
    ret
;2、设置前景色
sub2:
    push es
    push bx
    push cx
    mov bx,0B800H
    mov es,bx
    mov cx,2000
    mov bx,1
sub2s:
    and byte ptr es:[bx],11111000B
    or es:[bx],al
    add bx,2
    loop sub2s
    pop cx
    pop bx
    pop es
    ret
;3、设置背景色
sub3:
    push es
    push bx
    push cx
    mov cl,4
    shl al,cl
    mov bx,0B800H
    mov es,bx
    mov cx,2000
    mov bx,1
sub3s:
    and byte ptr es:[bx],10001111B
    or es:[bx],al
    add bx,2
    loop sub3s
    pop cx
    pop bx
    pop es
    ret
;4、向上滚动一行
sub4:
    push bx
    push es
    push si
    push di
    push cx
    mov bx,0B800H
    mov es,bx
    mov ds,bx
    mov si,160
    mov di,0
    mov cx,24
    cld         ;清除df位，利用movsb做si相加的移动
sub4s:
    push cx
    mov cx,160
    rep movsb
    pop cx
    loop sub4s
    mov cx,80

sub4s1:
    mov byte ptr es:[si],' '
    add si,2
    loop sub4s1
    pop cx
    pop di
    pop si
    pop es
    pop bx
    ret

code ends
end start