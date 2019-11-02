segment code;
org 100H;

begin:
;
mov dx,mess1;
call EchoMess;
call GetHex;
mov [dataA],ax;
call NewLine;
;
mov dx,mess2;
call EchoMess;
call GetHex;
mov [dataB],ax;
call NewLine;
;
mov ax,[dataA]
mov bx,[dataB]
call  Factor
mul bx;;dx-31-16 ax 15-0
div cx;;ax-quotient
call EchoDec

mov ah,4ch
int 21h

;/***Factor***/
Factor:
push ax
push bx
xor cx,cx

LL1Factor:
xor dx,dx
div bx
mov ax,bx
mov bx,dx
or bx,bx
jz LL2Factor
jmp LL1Factor

LL2Factor:
mov cx,ax
pop bx
pop ax
ret

;/***EchoDec***/
EchoDec:
mov bx,10
xor dx,dx
push dx

LL1EchoDec:
xor dx,dx
div bx
add dx,30h
push dx
or ax,ax
jz LL2EchoDec
jmp LL1EchoDec

LL2EchoDec:
pop dx
or dx,dx
jz LL3EchoDec
call PutChar
jmp LL2EchoDec

LL3EchoDec:
ret

;/***EchoMess***/
;DS:DX
EchoMess:
push bx
mov bx,dx

LL1EchoMess:
mov dl,[bx]
inc bx
or dl,dl
jz LL2EchoMess
call PutChar
jmp LL1EchoMess

LL2EchoMess:
pop bx
ret

;/***GetHex***/
GetHex:
push bx
xor bx,bx

LL1GetHex:
call GetChar
xor ah,ah
cmp al,40h
jnl LL2GetHex
cmp al,30h
jl LL2GetHex
sub al,30h
imul bx,10
add bx,ax
jmp LL1GetHex

LL2GetHex:
mov ax,bx
pop bx
ret

;/***NewLine***/
NewLine:
mov ah,2
mov dl,0dh
int 21h
mov dl,0ah
int 21h
ret

;/***GetChar***/
GetChar:
mov ah,1
int 21h
ret

;/***PutChar***/
PutChar:
mov ah,2
int 21h
ret

;/***const***/
mess1 db "print A:",0
mess2 db "print B:",0
dataA dw 0
dataB dw 0