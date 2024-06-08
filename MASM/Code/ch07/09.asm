assume cs:code,ds:data
data segment
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'
    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4027,5635,8226
    dw 11542,14430,15257,17800
data ends
table segment
    db 21 dup ('year summ ne ?? ')
table ends
code segment
start:
    mov ax,data
    mov ds,ax
    mov ax,table
    mov es,ax
    mov cx,21
    mov bx,0
    mov si,0
    mov di,168
s:  mov ax,[bx]
    mov es:[si],ax
    mov ax,2[bx]
    mov es:[si+2],ax
    mov ax,84[bx]
    mov es:[si+5],ax
    mov ax,86[bx]
    mov es:[si+7],ax
    mov ax,168[di]
    mov es:[si+10],ax
    mov dx,es:[si+7]
    mov ax,es:[si+5]
    div word ptr es:[si+10]
    mov es:[si+13],ax
    add bx,4
    add si,16
    add di,2
    loop s
    mov ax,4c00H
    int 21H
code ends
end start