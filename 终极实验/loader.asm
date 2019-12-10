Signature	 equ   0
Length	     equ   6
Start 	     equ   8
ZONELOW   equ   1000H
ZONEHIGH  equ   9000H
ZONETEMP  equ   07E0H


section   text
bits    16
org    7C00H

Begin:
    MOV  AX,0
    CLI
    MOV  SS,AX
    MOV  SP,7C00H

LAB1:
    CLD
    PUSH CS
    POP  DS
    MOV  AX,ZONETEMP
    MOV  WORD [DiskAP+6],AX
    MOV  ES,AX

    MOV  DX,mess0
    CALL PutStr
    CALL GetSecAdr
    OR   EAX,EAX
    JZ   Over
    
    MOV  [DiskAP+8],EAX
    CALL ReadSec
    JC   LAB7

    CMP  DWORD[ES:Signature],"YANG"
    JNZ  LAB6

    MOV  CX,[ES:Length]
    CMP  CX,0
    JZ   LAB6
    ADD  CX,511
    SHR  CX,9

    MOV  AX,[ES:Start+2]
    CMP  AX,ZONELOW
    JB   LAB2
    CMP  AX,ZONEHIGH
    JB   LAB3

LAB2:
    MOV  AX,ZONELOW

LAB3:
    MOV  WORD[DiskAP+6],AX

    MOV  ES,AX
    XOR  DI,DI
    PUSH DS
    PUSH ZONETEMP
    POP  DS
    XOR  SI,SI
    PUSH CX
    MOV  CX,128
    REP  MOVSD
    POP  CX
    POP  DS

    DEC  CX
    JZ   LAB5

LAB4:
    ADD  WORD[DiskAP+6],20H
    INC  DWORD[DiskAP+8]
    CALL ReadSec
    JC   LAB7
    LOOP LAB4

LAB5:
    MOV  [ES:Start+2],ES
    CALL FAR [ES:Start]
    JMP  LAB1

LAB6:
    MOV  DX,mess1
    CALL PutStr
    JMP  LAB1

LAB7:
    MOV  DX,mess2
    CALL PutStr
    JMP  LAB1

Over:
    MOV  DX,mess3
    CALL PutStr

Halt:
    HLT
    JMP  SHORT Halt

ReadSec:
    PUSH DX
    PUSH SI
    MOV  SI,DiskAP
    MOV  DL,80H
    MOV  AH,42H
    INT  13H
    POP  SI
    POP  DX
    RET

GetSecAdr:
    MOV  DX,buffer
    CALL GetDStr
    MOV  AL,0DH
    CALL PutChar
    MOV  AL,0AH
    CALL PutChar
    MOV  SI,buffer+1
    CALL DSTOB
    RET

DSTOB:
    XOR  EAX,EAX
    XOR  EDX,EDX

    .next:
    LODSB
    CMP  AL,0DH
    JZ   .ok
    AND  AL,0FH
    IMUL EDX,10
    ADD  EDX,EAX
    JMP  SHORT .next

    .ok:
    MOV  EAX,EDX
    RET

GetDStr:

    PUSH SI
    MOV  SI,DX
    MOV  CL,[SI]
    CMP  CL,1
    JB   .lab16
    INC  SI
    XOR  CH,CH

    .lab11:
    CALL GetChar
    OR   AL,AL
    JZ   SHORT  .lab11
    CMP  AL,0DH
    JZ   SHORT .lab15
    CMP  AL,08H
    JZ   SHORT .lab14
    CMP  AL,20H
    JB   SHORT .lab11

    CMP  AL,'0'
    JB   SHORT .lab11
    CMP  AL,'9'
    JA   SHORT .lab11

    CMP  CL,1
    JA   SHORT .lab13

    .lab12:
    MOV  AL,07H
    CALL PutChar
    JMP  SHORT .lab11

    .lab13:
    CALL PutChar
    MOV  [SI],AL
    INC  SI
    INC  CH
    DEC  CL
    JMP  SHORT .lab11

    .lab14:
    CMP  CH,0
    JBE  .lab12
    CALL PutChar
    MOV  AL,20H
    CALL PutChar
    MOV  AL,08H
    CALL PutChar
    DEC  SI
    DEC  CH
    INC  CL
    JMP  SHORT .lab11

    .lab15:
    MOV  [SI],AL

    .lab16:
    POP  SI
    RET


PutChar:
    MOV  BH,0
    MOV  AH,14
    INT  10H
    RET

GetChar:
    MOV  AH,0
    INT  16H
    RET

PutStr:
    MOV  BH,0
    MOV  SI,DX

.LAB1:
    LODSB
    OR   AL,AL
    JZ   .LAB2
    MOV  AH,14
    INT  10H
    JMP  .LAB1

.LAB2:
    RET

DiskAP:
    DB   10H
    DB   0
    DW   1
    DW   0
    DW   ZONETEMP
    DD   0
    DD   0

buffer:
    DB   9
    DB   "123456789"

mess0 db "Input sector address",0
mess1 db "Invalid code...",0DH,0AH,0
mess2 db "Reading disk error...",0DH,0AH,0
mess3 db "Halt...",0

times 510-($-$$) db 0
db 55H,0AAH