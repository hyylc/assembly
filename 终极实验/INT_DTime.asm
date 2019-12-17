Signature   DB  "YANG"
Version     DW  1
Length      DW  end_of_text
Start       DW  Begin
Zoneseg     DW  2800H
Reserved    DD  0

section     text
bits        16
;-------------------------
Entry_1CH:
    DEC     BYTE [CS:count]
    JZ      ETIME
    IRET
    ;
ETIME:
    MOV     BYTE[CS:count],18
    ;
    STI
    PUSHA
    CALL    get_time
    CALL    EchoTime
    POPA
    IRET
;-------------------------
get_time:
    MOV     AL,4
    OUT     70H,AL
    IN      AL,71H
    MOV     CH,AL
    MOV     AL,2
    OUT     70H,AL
    IN      AL,71H
    MOV     CL,AL
    MOV     AL,0
    OUT     70H,AL
    IN      AL,71H
    MOV     DH,AL
    RET
;-------------------------
%define     ROW     18
%define     COLUMN  60
EchoTime:
    PUSH    SI
    ;
    PUSH    DX
    PUSH    CX
    MOV     BH,0
    MOV     AH,3
    INT     10H
    MOV     SI,DX
    MOV     DX,(ROW<<8)+COLUMN
    MOV     AH,2
    INT     10H
    POP     CX
    POP     DX
    ;
    MOV     AL,CH
    CALL    EchoBCD
    MOV     AL,':'
    CALL    PutChar
    MOV     AL,CL
    CALL    EchoBCD
    MOV     AL,':'
    CALL    PutChar
    MOV     AL,DH
    CALL    EchoBCD
    ;
    MOV     DX,SI
    MOV     AH,2
    INT     10H
    POP     SI
    RET

;---------------------------
EchoBCD:
    PUSH    AX
    SHR     AL,4
    ADD     AL,'0'
    CALL    PutChar
    POP     AX
    AND     AL,0FH
    ADD     AL,'0'
    CALL    PutChar
    RET

;---------------------------
PutChar:
    MOV     BH,0
    MOV     AH,14
    INT     10H
    RET

;---------------------------
count   DB  1
old1ch  DD  0
;---------------------------
Begin:
    MOV     AX,CS
    MOV     DS,AX
    MOV     SI,1CH*4
    MOV     AX,0
    MOV     ES,AX
    MOV     AX,[ES:SI]
    MOV     [old1ch],AX
    MOV     AX,[ES:SI+2]
    MOV     [old1ch+2],AX

    CLI
    MOV     AX,Entry_1CH
    MOV     [ES:SI],AX
    MOV     AX,CS
    MOV     [ES:SI+2],AX
    STI

Continue:
    MOV     AH,0
    INT     16H
    CMP     AL,20H
    JB      Continue
    CALL    PutChar
    CMP     AL,'0'
    JNZ     Continue

    MOV     AL,0DH
    CALL    PutChar
    MOV     AL,0AH
    CALL    PutChar

    MOV     EAX,[CS:old1ch]
    MOV     [ES:SI],EAX

    RETF
end_of_text: