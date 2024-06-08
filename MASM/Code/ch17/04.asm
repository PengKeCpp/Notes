;1 用ah寄存器传递功能号：读:0,写:1
;2 用dx寄存器传递要读写的扇区的逻辑扇区号;
;3 用es:bx指向存储要读出数据或写入数据的内存区
assume cs:code
code segment
start:
    ;安装int7ch中断程序
    call install7ch
    ;初始化int7ch中断例程的参数
    mov ax,0B800H
    mov es,ax
    mov bx,160*12+40*2
    mov ah,0
    mov dx,1439
    ;call int7ch
    int 7ch
    ;退出程序
    mov ax,4c00H
    int 21H

install7ch:
    ;保存用到的寄存器
    push ax
    push si
    push es
    push cx
    push ds
    mov ax,cs
    mov ds,ax
    mov si,offset int7ch
    mov ax,0
    mov es,ax
    mov di,200H
    mov cx,offset int7chend - offset int7ch
    ;安装int7ch
    cld
    rep movsb
    ;重新设置7ch的地址
    cli
    mov word ptr es:[7cH*4+2],0H
    mov word ptr es:[7cH*4],200H
    sti
return:
    pop ds
    pop cx
    pop es
    pop si
    pop ax
    ret
int7ch:
    cmp ah,1
    ja int7chexit
    push ax
    push bx
initparams:
    push ax
    ;计算dh面号的值
    mov ax,dx
    mov dx,0
    mov bx,1440
    div bx
    ;dx保存余数,ax保存商
    push ax     ;保存得到的商
    mov ax,dx
    mov bl,18
    div bl
    ;ax-->ah 余数  al 商
    mov ch,al       ;初始化磁道号
    inc ah
    mov cl,ah       ;初始化扇区号
    pop ax
    mov dh,al       ;初始化面号
    pop ax
function:
    mov al,1        ;扇区数
    mov dl,0        ;驱动器号
    add ah,2        ;初始化功能号
    int 13H

    pop bx          ;恢复现场
    pop ax
int7chexit: 
    iret            ;==>pop ip,pop cs ret
int7chend:nop
code ends
end start