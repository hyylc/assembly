Signature db "YANG"
Version dw 1
Length dw end_of_text
Start dw Begin
Zoneseg dw 0088H
Reserved dd 0

section text
bits 16

Begin:
MOV AL,0
MOV AH,5
INT 10H

CLD
MOV AX,CS
MOV DS,AX
MOV SI,hello

MOV AX,0B800H
MOV ES,AX
MOV DI,(80*5+40)*2

MOV AH,47H

LAB1:
LODSB
OR AL,AL
JZ LAB2
STOSW
JMP LAB1

LAB2:
RETF

hello db "hello,world",0
end_of_text: