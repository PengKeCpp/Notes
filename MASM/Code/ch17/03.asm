;3.5英寸软盘    C盘  0面0道1扇区
;2个面
;80个磁道
;18个扇区
;单个扇区为512个字节
;2 * 80 * 18 * 512 = 1440kb = 1.44MB

;软盘===> 0:200H 读扇区

;从0:200H位置读取
mov ax,0
mov es,ax
mov bx,200H

mov al,1        ;操作的扇区个数
mov ch,0        ;磁道号
mov cl,1        ;扇区号
mov dl,0        ;驱动器号   0:软驱A    1:软驱B  80H:硬盘C 81H:硬盘D
mov dh,0        ;面号  

mov ah,2        ;功能号 ah=2表示读取 ah=3 往软盘里面写
int 13H

;0:200H===>软盘

mov ax,0
mov es,ax
mov bx,200H

mov al,1        ;操作的扇区个数
mov ch,0        ;磁道号
mov cl,1        ;扇区号
mov dl,0        ;驱动器号
mov dh,0        ;面号
mov ah,3        ;功能号
int 13H

;将当前屏幕内容保存到0面0磁道1扇区中
assume cs:code
code segment
start:
    mov ax,0
    mov es,ax
    mov bx,0

    mov al,8    ;扇区个数
    mov ch,0    ;磁道号
    mov cl,1    ;扇区号     
    mov dl,0    ;驱动号
    mov dh,0    ;面号

    mov ah,3
    int 13H
    mov ax,4c00H
    int 21H
code ends
end start