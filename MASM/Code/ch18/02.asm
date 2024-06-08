assume cs:code,ds:data,ss:stack
stack segment
    db 128 dup(0)
stack ends
data segment
    db 128 dup(0)
data ends
code segment
start:
    ;初始化寄存器
    mov ax,stack
    mov ss,ax
    mov sp,128

    mov ax,data
    mov ds,ax
    ;安装程序
    call save_old_int9
    call boot_install
    
    ;运行程序
    mov ax,0
    push ax
    mov ax,7E00H
    push ax
    ;设置cs:ip,开始从安装的程序运行
    retf
    ;程序退出
    mov ax,4c00H
    int 21H
boot_install:
    ;ds:si--->es:di
    mov bx,cs
    mov ds,bx
    mov si,offset boot      ;ds:si
    mov bx,0
    mov es,bx
    mov di,7E00H            ;es:di
    mov cx,offset boot_end-offset boot
    cld         ;设置移动方向
    rep movsb
    ret

boot:
    jmp boot_start
    ;定义常量
    OPTION_1 db '1) reset pc',0
    OPTION_2 db '2) start system',0
    OPTION_3 db '3) show clock',0
    OPTION_4 db '4) set clock',0

    OPTION_ADDRESS dw offset OPTION_1 - offset boot + 7E00H
                   dw offset OPTION_2 - offset boot + 7E00H
                   dw offset OPTION_3 - offset boot + 7E00H
                   dw offset OPTION_4 - offset boot + 7E00H
    TIME_ADDRESS db 9,8,7,4,2,0
    TIME_STRING db '00/00/00 00:00:00',0
    time_buffer db 12 dup(0)
    top dw 0
    temp db 0
boot_start:
    call init_reg
    call clear_screen
    call show_option
    call choose_option

choose_option: 
    call clear_buff
    ;输入字符
    mov ah,0
    int 16H
    ;ah 为扫描码，al为ascill码
    cmp al,'1'
    je isChooseOne
    cmp al,'2'
    je isChooseTwo
    cmp al,'3'
    je isChooseThree
    cmp al,'4'
    je isChooseFour

isChooseOne:
    mov di,160*4
    mov byte ptr es:[di],'1'
    jmp choose_option
isChooseTwo:
    mov di,160*4
    mov byte ptr es:[di],'2'
    jmp choose_option
isChooseThree:
    mov di,160*4
    mov byte ptr es:[di],'3'
    call show_clock
    jmp boot
isChooseFour:
    mov di,160*4
    mov byte ptr es:[di],'4'
    call set_clock
    jmp boot

;==========================================
set_clock:
    mov di,160*8
    mov si,offset time_buffer - offset boot + 7E00H
    mov top,0
set_clock_begin:
    call input_time_buffer
    call set_buffer_to_cmos
set_clock_end:
ret

;============================================
input_time_buffer:
    push ax
    ;清空缓冲区
input_time_begin:
    call clear_buff
    ;键盘输入
    mov ah,0
    int 16H
    cmp al,20H
    jb nochar
    mov ah,0
    mov temp,al
    call charstack
    mov ah,2
    call charstack
    jmp input_time_begin
input_time_buffer_end:
    pop ax
ret

nochar:
    ;判断是backspace还是enter键
    cmp ah,1CH
    je enter1
    cmp ah,0EH
    je backspace
    jmp input_time_begin
enter1:
    jmp input_time_buffer_end
backspace:
    ;跳转
    mov ah,1
    call charstack   
    mov ah,2
    call charstack
    jmp input_time_begin

charstack:
    push cx
    push bx
    push ax
    push si
    push di
charstack_begin:

    cmp ah,0
    je charpush
    cmp ah,1
    je charpop
    cmp ah,2
    je charshow

charstack_ret:
    pop di
    pop si
    pop ax
    pop bx
    pop cx
ret

charpush:
    cmp top,12
    jnb charstack_ret
    cmp al,48
    jb charstack_ret
    cmp al,57
    ja charstack_ret
    mov bx,top
    mov al,temp
    mov ds:[bx+si],al
    inc top
    jmp charstack_ret

charpop:
    cmp top,0
    je charstack_ret
    dec top
    mov bx,top
    mov al,ds:[bx+si]
    mov temp,al
    jmp charstack_ret

charshow:
    cmp top,0
    je charstack_empty
    mov cx,top
    mov bx,0
s:  mov al,ds:[si+bx]
    mov es:[di],al
    mov byte ptr es:[di+1],08H
    inc bx
    add di,2
    loop s
;当字符栈为空时，将0位置赋值为空
charstack_empty:
    mov byte ptr es:[di],' '
    jmp charstack_ret

;==========================================
set_buffer_to_cmos:
    push ax
    push dx
    push bx
    push cx
    push si
    push di

    mov dx,0
    mov ax,top
    mov bx,2
    div bx
    mov cx,ax
    mov si,offset TIME_ADDRESS - offset boot + 7E00H
    mov di,offset time_buffer - offset boot + 7E00H
    cmp cx,0
    je handle_remainder
set_time:
    mov al,ds:[si]
    out 70H,al
    mov ah,ds:[di]
    mov al,ds:[di+1]
    sub al,30H
    sub ah,30H
    shl ah,1
    shl ah,1
    shl ah,1
    shl ah,1
    and al,0FH
    add al,ah
    out 71H,al
    add di,2
    inc si
    loop set_time
    cmp dx,0
    jne handle_remainder
set_buffer_to_cmos_ret:
    pop di
    pop si
    pop cx
    pop bx
    pop dx
    pop ax
ret

handle_remainder:
    ;读出原来的数值
    mov al,ds:[si]
    out 70H,al
    in al,71H
    ;al保存原来的值
    mov ah,ds:[di]
    sub ah,30H
    shl ah,1
    shl ah,1
    shl ah,1
    shl ah,1
    and al,0FH
    add al,ah
    out 71H,al
    jmp set_buffer_to_cmos_ret

;==========================================
;ZF=0,AH:扫描码, AL:ASCII码
;ZF=1,表示缓冲区为空
;jz=jmp if zero 即标志为1就跳转
clear_buff:
    mov ah,1
    int 16H
    jz clear_buff_ret
    mov ah,0
    int 16H
    loop clear_buff
clear_buff_ret:
ret
;==========================================
show_clock:
    call show_time
    call set_new_int9
;循环读取CMOS中的字符
init_param:
    mov cx,6
    mov si,TIME_ADDRESS - offset boot + 7E00H
    mov di,160*20+35*2
show_data:
    mov al,ds:[si]
    out 70H,al
    in al,71H
    mov ah,al
    shr ah,1
    shr ah,1
    shr ah,1
    shr ah,1
    and al,0FH
    add ah,30H      ;加上30H表示对应的ASCII码
    add al,30H
    mov es:[di],ah
    mov es:[di+2],al
    add di,6
    inc si
    loop show_data
    jmp init_param

;==========================================
show_time:
    push ax
    push bx
    push di
    push si
    push cx

    mov di,160*20+35*2
    mov si,offset TIME_ADDRESS - offset boot + 7E00H
    mov bx,offset TIME_STRING - offset boot + 7E00H
    mov cx,6
    push bx
show_time_begin:
    mov al,ds:[si]
    out 70H,al      ;执行读取的单元号
    in al,71H      ;读取的数值
    mov ah,al       ;BCD码存储的方式 一个字节存储
    shr ah,1        ;高4位BCD码表示十位,低4位BCD码表示个位
    shr ah,1
    shr ah,1
    shr ah,1
    and al,0FH

    add ah,30H      ;加上30H表示对应的ASCII码
    add al,30H
    mov ds:[bx],ah
    mov ds:[bx+1],al
    add si,1
    add bx,3
    loop show_time_begin
    pop bx
show_time_char:
    mov al,ds:[bx]
    cmp al,0
    je show_time_end
    mov es:[di],al
    add bx,1
    add di,2
    loop show_time_char
show_time_end:
    pop cx
    pop si
    pop di
    pop bx
    pop ax
    ret
;=========================================================
set_new_int9:
    cli
    mov ax,offset new_int9 - offset boot + 7E00H
    mov ds:[4*9],ax
    mov word ptr ds:[4*9+2],0H
    sti
    ret
new_int9:
    push ax
    ;安装新的int9中断指令
    ;从键盘缓冲区中读入数据
    call clear_buff
    in al,60H
    ;调用原有9号中断例程
    pushf               ;保存现场 获取中断类型码n，pushf IF=0，TF=0 push CS、push IP CS = 4*n+2, IP=4*n 转向执行中断例程
    call dword ptr ds:[200H]
    cmp al,01H
    je is_esc
    ;cmp al,3BH
    cmp al,0DH
    jne exit_int9
    call change_screen_color

exit_int9:
    pop ax
    iret

change_screen_color:
    push cx
    push bx
    push es
    mov bx,160*20+35*2+1
    mov cx,17
change_color:
    inc byte ptr es:[bx]
    add bx,2
    loop change_color

change_screen_color_ret:
    pop es
    pop bx
    pop cx
ret

is_esc:
    pop ax
    ;将中断例程还原
    ;关键代码
    add sp,4
    popf
    ret

show_date_over:
    call set_old_int9
    ret

set_old_int9:
    cli
    push ds:[200H]
    pop ds:[4*9]
    push ds:[202H]
    pop ds:[4*9+2]
    sti
    ret

;===========================================================
clear_screen:
    ;初始化偏移地址
    mov si,0
    mov cx,2000

sub_clear_screen:
    mov al,' '
    mov es:[si],al
    add si,2
    loop sub_clear_screen
    ret
;==================================================
show_option:
    ;ds:[si]---->es:[di]
    mov di,160*12+35*2
    mov si,offset OPTION_ADDRESS - offset boot + 7E00H
    mov cx,4
show_option_begin:
    mov bx,ds:[si]
    call show_string
    add si,2
    add di,160
    loop show_option_begin
    ret

show_string:
    ;保存寄存器
    push ds
    push es
    push ax
    push di
    push si
    push bx
    
show_char: 
    mov al,ds:[bx]
    cmp al,0
    je show_string_ret
    mov es:[di],al
    inc bx
    add di,2
    jmp show_char
show_string_ret:
    pop bx
    pop si
    pop di
    pop ax
    pop es
    pop ds
    ret
;==================================================
init_reg:
    mov ax,0B800H
    mov es,ax
    mov ax,0
    mov ds,ax
    ret
;==================================================
save_old_int9:
    ;保存原来int9的中断地址到200H中
    mov bx,0
    mov es,bx
    push es:[4*9]
    pop es:[200H]
    push es:[4*9+2]
    pop es:[202H]
    ret

boot_end:nop

code ends
end start