Signature   db  "YANG"
Version     dw  1
Length      dw  end_of_text
Start       dw  Begin
Zoneseg     dw  1500H
Reserve     dd  0

PORT_KEY_DAT    EQU     0X60
PORT_KEY_STA    EQU     0X64
section text
bits    16
;-------------------------

Begin:
    MOV     AX,0
    MOV     DS,AX
    CLI
    MOV     WORD[9*4],int09h_handler
    MOV     [9*4+2],CS
    ;
Next:
    MOV     AH,0
    INT     16H
    ;
    MOV     AH,14
    INT     10H
    ;
    CMP     AL,0DH
    JNZ     Next
    ;
    MOV     AH,14
    MOV     AL,0AH
    INT     10H
    ;
    MOV     AL,0DH
    INT     10H
    MOV     AL,0AH
    INT     10H
    ;
    
    RETF

int09h_handler:
    PUSHA
    
    MOV     AL,0ADH
    OUT     PORT_KEY_STA,AL
    IN      AL,PORT_KEY_DAT
    ;
    STI
    CALL    Int09hfun
    ;
    CLI
    MOV     AL,0AEH
    OUT     PORT_KEY_STA,AL
    ;
    MOV     AL,20H
    OUT     20H,AL
    ;
    POPA
    IRET
Int09hfun:
    CMP     AL,1CH
    JNZ     .LAB1
    MOV     AH,AL
    MOV     AL,0DH
    JMP     SHORT .LAB2

.LAB1:
    CMP     AL,02H
    JB      .LAB3
    CMP     AL,0AH
    JA      .LAB3
    MOV     AH,AL
    ADD     AL,2FH

.LAB2:
    CALL    Enqueue

.LAB3:
    RET

;-----------------------

Enqueue:
    PUSH    DS
    MOV     BX,40H
    MOV     DS,BX
    MOV     BX,[001CH]
    MOV     SI,BX
    ADD     SI,2
    CMP     SI,003EH
    JB      .LAB1
    MOV     SI,001EH
.LAB1:
    CMP     SI,[001AH]
    JZ      .LAB2
    MOV     [BX],AX
    MOV     [001CH],SI
.LAB2:
    POP     DS
    RET
end_of_text:
