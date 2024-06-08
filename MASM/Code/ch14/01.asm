assume cs:code
code segment
start:
    mov al,2
    out 70H,al
    in al,71H
    mov ax,4c00H
    int 21H
code ends
end start