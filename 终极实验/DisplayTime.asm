Signature db "YANG"
Version   dw 1
Length    dw end_of_text
Start     dw Begin
          dw 1300H
Reserved  dd 0

section text
bits 16

Begin:
    PUSH    CS
    POP     DS

NEXT:
    MOV     AL,9
    OUT     70H,AL
    IN      AL,71H
    MOV     [year],AL

    MOV     AL,8
    OUT     70H,AL
    IN      AL,71H
    MOV     [month],AL

    MOV     AL,7
    OUT     70H,AL
    IN      AL,71H
    MOV     [day],AL

    MOV     AL,4
    OUT     70H,AL
    IN      AL,71H
    MOV     [hour],AL
    
    
    MOV     AL,2
    OUT     70H,AL
    IN      AL,71H
    MOV     [minute],AL
    ;
    MOV     AL,0
    OUT     70H,AL
    IN      AL,71H
    MOV     [second],AL
    ;
    MOV     AL,[year]
    CALL    EchoBCD
    MOV     AL,'/'
    CALL    PutChar
    MOV     AL,[month]
    CALL    EchoBCD
    MOV     AL,'/'
    CALL    PutChar
    MOV     AL,[day]
    CALL    EchoBCD
    MOV     AL,20H
    CALL    PutChar
    ;
    MOV     AL,[hour]
    CALL    EchoBCD
    MOV     AL,':'
    CALL    PutChar
    MOV     AL,[minute]
    CALL    EchoBCD
    MOV     AL,':'
    CALL    PutChar
    MOV     AL,[second]
    CALL    EchoBCD
    MOV     AL,0DH
    CALL    PutChar
    MOV     AL,0AH
    CALL    PutChar
    ;
    MOV     AH,0
    INT     16H
    CMP     AL,0DH
    JNZ     NEXT
    ;
    RETF

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

PutChar:
    MOV     BH,0
    MOV     AH,14
    INT     10H
    RET

year    db  0
month   db  0
day     db  0
hour    db  0
second  db  0
minute  db  0
end_of_text: