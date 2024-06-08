;1、调用16H中断程序, 判断键盘缓冲区中的输入 ah保存扫描码，al保存字符键
;2、判断al的值，如果小于20H表示不是字母
    ;2.1、非字母时，判断时backspace 还是enter键
    ;2.2、backspace键则从栈中弹出一个字符并显示字符栈中所有的字符，继续执行1
    ;2.3、enter键则将0入栈，并显示字符栈中所有的字符，并返回
;3、如果是字符,入栈并显示字符栈中的字符
    ;3.1、根据ah的值判断功能号, 使用将程序入口地址保存到直接定制表中的方式调用功能子程序
    ;3.2、功能号ah=0，将字符入栈，并显示字符栈中所有字符
    ;3.3、功能号ah=1，将字符栈出栈，并显示字符栈中所有字符
    ;3.4、功能号ah=2，显示字符栈中所有字符
assume cs:code,ds:data
data segment
    db 30 dup(0)
data ends
code segment
start:
    ;初始化寄存器
    ;初始化ds:si 作为指向
    mov ax,data
    mov ds,ax
    mov si,0
    ;显示的行和列
    mov dh,12
    mov dl,20
    ;调用子程序去处理
    call getstr
exit:
    mov ax,4c00H
    int 21H

getstr:
    ;将使用到的寄存器进行保存
    push ax
getstrs:
    ;判断输入
    mov ah,0
    int 16H
    ;ah为扫描码, al为ascii码
    cmp al,20H
    jb nochar
    mov ah,0
    call charstack
    mov ah,2
    call charstack
    jmp short getstrs
nochar:
    cmp ah,0EH
    je backspace
    cmp ah,1CH
    je enter1
    jmp getstrs ; 持续接收输入
    ; ah 表示功能号，0表示入栈，1表示出栈，2表示显示字符栈中的字符
    ; ah=0,al表示要入栈的字符
    ; ah=1,al表示保存出栈的字符
backspace:
    mov ah,1
    call charstack
    mov ah,2
    call charstack
    jmp getstrs
    ;如果是Enter键, 向字符栈中压入0, 返回
enter1:
    ;给栈最后一个位置置为0
    mov al,0
    mov ah,0
    call charstack
    mov ah,2
    call charstack
getstrend:
    pop ax
    ret

charstack:
    jmp short subroutine
    table dw charpush,charpop,charshow
subroutine:
    ;保存寄存器
    push ax
    push bx
    push es
    push dx
    push di
    ;异常检测, 查看ah的值是否大于2
    cmp ah,2
    ja sret
    mov bl,ah
    mov bh,0
    add bx,bx
    jmp word ptr table[bx]

; 入栈将al的值放入到top的位置, 同时top加1
charpush:
    mov ds:[si],al
    inc si
    jmp sret
; 出栈, 将栈顶元素保存到al中，同时top减1
charpop:
    cmp si,0
    je sret
    dec si
    mov al,es:[si]
    mov byte ptr ds:[si],' '
    jmp sret
charshow:
    ;dh行,dl列
    mov ax,0B800H
    mov es,ax
    mov al,160
    mul dh
    ;ax为当前要展示的位置
    mov dh,0
    add dx,dx
    add ax,dx
    mov di,ax
    mov bx,0
charshows:
    cmp bx,si
    jne noempty
    mov al,ds:[bx]
    mov es:[di],al
    jmp sret
noempty:
    ;将栈中的字符复制到显存中
    mov al,ds:[bx]
    mov es:[di],al
    ;将字符串的最后一个字符位置置为空
    mov byte ptr es:[di+2],' '
    add di,2
    inc bx
    jmp charshows
sret:
    pop di
    pop dx
    pop es
    pop bx
    pop ax
    ret
code ends
end start