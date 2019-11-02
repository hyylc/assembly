segment code;
org 100H;

mov ax,0F000H;
mov ds,ax;

xor dx,dx
xor bx,bx

call mem
call print
call ADD

mov ax,bx

call dtob

mov ah,4ch;
int 21h;

mem:
	mov cx,100
	mov di,0

	start:
	mov byte[di],cl
	inc di
	loop start

	ret

print:
	mov di,0
	mov cx,100

	start1:
	mov dl,[di]
	inc di
	;add dl,30h
	mov ah,2
	int 21h
	;sub dl,30h
	loop start1

	mov ah,2
	mov dl,0dh
	int 21h
	mov dl,0ah
	int 21h
	ret

ADD:
	mov di,0
	mov cx,100

	start2:
	mov dl,[di]
	inc di
	add bx,dx
	loop start2

	ret

dtob:
		
		mov bx, 10
		mov cx, 0
		push cx

		lc:
		xor dx, dx
		div bx
		add dl, 30H
		push dx
		cmp ax, 0
		jz ok
		jmp lc

		ok :
		pop dx
		cmp dl,0
		jz ok1
		mov ah,2
		int 21h
		jmp ok
		
		ok1:
		ret
	


