assume cs:codesg

codesg segment

    mov ax,0123H
    mov bx,456H
    add ax,bx
    add ax,ax
    
    mov ax,4c00H
    int 21H
codesg ends
end