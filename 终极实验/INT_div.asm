section text
bits    16
Signature   db  "YANG"
Version     dw  1
Length      dw  end_of_text
Start       dw  Begin
Zoneseg     dw  1800H
Reserve     dd  0
;-------------------------
Begin:
    MOV     AX,0
    MOV     DS,AX
    CLI
    MOV     WORD[0*4],int00h_handler
    MOV     [0*4+2],CS
    STI
    ;

    MOV     BH,0
    MOV     AH,14
    MOV     AL,'#'
    INT     10H
    ;
    MOV     AX,600
    MOV     BL,2
    DIV     BL
LABV:
    MOV     AH,14
    MOV     AL,0DH
    INT     10H
    MOV     AL,0AH
    INT     10H
    ;
    RETF
;------------------------
int00h_handler:
    STI
    PUSHA
    PUSH    DS
    MOV     BP,SP
    ;
    PUSH    CS
    POP     DS
    MOV     DX,mess
    CALL    PutStr
    ;
    ADD     WORD[BP+18],2
    POP     DS
    POPA
    ;
    IRET

mess    DB      "Divide overflow",0

PutStr:
    MOV     BH,0
    MOV     SI,DX
.LAB1:
    LODSB
    OR      AL,AL
    JZ      .LAB2
    MOV     AH,14
    INT     10H
    JMP     .LAB1
.LAB2:
    RET
end_of_text: