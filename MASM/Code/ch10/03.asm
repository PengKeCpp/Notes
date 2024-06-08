assume cs:code,ds:data,ss:stack
stack segment
    db 16 dup(0)
stack ends
data segment
    db 'Welcome to masm!',0
data ends

code segment
start:
    mov dh,8
    mov dl,3
    mov cl,2
    mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    mov si,0
    call show_str

    mov ax,4c00H
    int 21H
show_str:
    sub dh,1
    mov al,dh
    mov ah,160
    mul ah
   ; mov dh,0
   ; add ax,dx
    add ax,3
    mov di,ax
    mov dl,cl
    mov ax,0B800H
    mov es,ax
s:  mov ch,0
    mov cl,[si]
    jcxz ok
    mov al,[si]
    mov es:[di],al
    inc di
    mov al,dl
    mov es:[di],al
    inc si
    inc di
    loop s
ok: ret
code ends

end start