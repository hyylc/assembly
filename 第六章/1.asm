segment text
org 100h

mov ax,cs
mov ds,ax

mov cx,9

start:
mov dx,hello
mov ah,9
int 21h
loop start

mov ah,4ch
int 21h


hello db "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0dh,0ah,'$'