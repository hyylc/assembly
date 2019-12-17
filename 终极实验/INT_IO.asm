Signature   DB  "YANG"
Version     DW  1
Length      DW  end_of_text
Start       DW  Begin
Zoneseg     DW  1A00H
Reserved    DD  0

section     text
bits        16

newhandler:
    STI
    PUSHA
    PUSH    DS
    PUSH    ES
    CALL    putchar
    POP     ES
    POP     DS
    POPA
    IRET

putchar:
    PUSH    AX
    MOV     AX,0B800H
    MOV     DS,AX
    MOV     ES,AX
    POP     AX

    CALL    get_lcursor
    ;
    CMP     AL,0DH
    JNZ     .LAB1
    MOV     DL,0
    JMP     .LAB3

.LAB1:
    CMP     AL,0AH
    JZ      .LAB2
    ;
    MOV     AH,BL
    MOV     BX,0
    MOV     BL,DH
    IMUL    BX,80
    ADD     BL,DL
    ADC     BH,0
    SHL     BX,1
    ;
    MOV     [BX],AX
    ;
    INC     DL
    CMP     DL,80
    JB      .LAB3
    MOV     DL,0
.LAB2:
    INC     DH
    CMP     DH,25
    JB      .LAB3
    DEC     DH
    CLD
    MOV     SI,80*2
    MOV     ES,AX
    MOV     DI,0
    MOV     CX,80*24
    REP     MOVSW
    ;
    MOV     CX,80
    MOV     DI,80*24*2
    MOV     AX,0X0720
    REP     STOSW

.LAB3:
    CALL    set_lcursor
    CALL    set_pcursor
    RET
;----------------------------
get_lcursor:
    PUSH    DS
    PUSH    0040H
    POP     DS
    MOV     DL,[0050H]
    MOV     DH,[0051H]
    POP     DS
    RET
;----------------------------
set_lcursor:
    PUSH    DS
    PUSH    0040H
    POP     DS
    MOV     [0050H],DL
    MOV     [0051H],DH
    POP     DS
    RET
;----------------------------
set_pcursor:
    MOV     AL,80
    MUL     DH
    ADD     AL,DL
    ADC     AH,0
    MOV     CX,AX
    ;
    MOV     DX,3D4H
    MOV     AL,14
    OUT     DX,AL
    MOV     DX,3D5H
    MOV     AL,CH
    OUT     DX,AL
    MOV     DX,3D4H
    MOV     AL,15
    OUT     DX,AL
    MOV     DX,3D5H
    MOV     AL,CL
    OUT     DX,AL
    RET

;----------------------------
Begin:
    MOV     AL,0
    MOV     AH,5
    INT     10H
    ;
    XOR     AX,AX
    MOV     DS,AX
    CLI
    MOV     WORD[90H*4],newhandler
    MOV     [90H*4+2],CS
    STI
    PUSH    CS
    POP     DS
    CLD
    MOV     SI,mess
    MOV     BL,17H
.LAB1:
    LODSB
    OR      AL,AL
    JZ      .LAB2
    INT     90H
    JMP     .LAB1
.LAB2:
    RETF

;
mess    DB      "No.90H handler is ready.",0DH,0AH,0
end_of_text: