.MODEL SMALL
.STACK 64
.DATA
    MSG1 DB 10,' Enter The Day [01 , 31]: $'
    MSG2 DB 10,10,' Enter The Month [01 , 12]: $'
    MSG3 DB 10,10,' Enter The Year [1800 , 2199]: $'
    
    DAY_INPUT DB ?      ;STORE THE ENTERD DAY
    MONTH_INPUT DB ?    ; //   //    //   MONTH
    YEAR_INPUT DW ?     ; //   //    //   YEAR
    
    CENTURY DB ?  
    YEAR DB ?     
    ANCHOR_DAY DB ?         ;THE SPECIAL DAY OF EVERY CENTUEY
    DOOMSDAY DB ?           ;DOOMSDAY PROCESSES AS A NUMBER
    SPECIAL_DAY DB ?        ;TO STORE SPECIAL DAYS FOR EVERY MONTH
    
    Sat DB 10,10,9,9,' [ Saturday ] $'    ;DISPLAY DAY NAMES
    Sun DB 10,10,9,9,' [ Sunday ]   $'
    Mon DB 10,10,9,9,' [ Monday ]   $'
    Tue DB 10,10,9,9,' [ Tuesday ]  $'
    Wed DB 10,10,9,9,' [ Wednesday ]$'
    Thu DB 10,10,9,9,' [ Thursday ] $'
    Fri DB 10,10,9,9,' [ Friday ]   $'
    
.CODE
    MAIN PROC FAR
    .STARTUP
    
         ;DISPLAY MSG1
     LEA DX,MSG1
     CALL PRINT_MSG
                         ;READ USER INPUT INTO DAY_INPUT VARIABLE
       
      CALL READ_DIGIT   ;DIGIT ONE [?]X         ;MOV AH, 01H
                                                ;INT 21H
                                                ;MOV AH, 00    ; SHURE THAT AH IS CLEAR
                                                ;SUB AL, 30H   ;CONVERT ENTERD DIGIT FROM CHARACTER TO DECIMAL
       MOV BX, 10
       MUL BX
       MOV CX, AX
       
       CALL READ_DIGIT      ;DIGIT TWO X[?]
       ADD CX, AX
       MOV DAY_INPUT, CL

     ;DISPLAY MSG2
     LEA DX,MSG2
     CALL PRINT_MSG
                            ;READ USER INPUT INTO MONTH_INPUT VARIABLE
       CALL READ_DIGIT          ;DIGIT ONE [?]X
       MOV BX, 10
       MUL BX
       MOV CX, AX
       CALL READ_DIGIT          ;DIGIT TWO X[?]XX
       ADD CX, AX
       MOV MONTH_INPUT, CL
       
     ;DISPLAY MSG3
     LEA DX,MSG3
     CALL PRINT_MSG
                               ;READ USER INPUT INTO YEAR_INPUT VARIABLE
       
       CALL READ_DIGIT      ;DIGIT ONE [?]XXX
       MOV BX, 1000
       MUL BX
       MOV CX, AX
       
       CALL READ_DIGIT      ;DIGIT TWO X[?]XX
       MOV BX, 100
       MUL BX
       ADD CX, AX
       
       CALL READ_DIGIT      ;DIGIT THREE XX[?]X
       MOV BX, 10
       MUL BX
       ADD CX, AX
       
       CALL READ_DIGIT      ;DIGIT FOUR XXX[?]
       ADD CX, AX
       MOV YEAR_INPUT, CX
    
    ;SEPARATE YEAR AND CENTURY
    MOV DX, 00              ;SURE THAT DX IS CLEAR
    MOV AX, YEAR_INPUT
    MOV BX, 100
    DIV BX                  ;DIV YEAR_INPUT BY 100 TO GET CENTURY AND YEAR
    MOV CENTURY, AL         ;FIRST TWO DIGITS FROM YEAR_INPUT
    MOV YEAR, DL            ;LAST TWO DIGITS FROM YEAR_INPUT
    
    ;DETECT ANCHOR_DAY
    
    CMP CENTURY, 18
    JZ Eighteen             ;JMP IN CASE OF CENTURY EQUAL 18
    JMP NOT_Eighteen        ;IF CENTURY NOT EQUAL 18 IT WILL OUT
    Eighteen:
    MOV ANCHOR_DAY, 7       ;IF CENTURY EQUAL 18 ? SET ANCHOR_DAY TO 7 (FRIDAY)
    NOT_Eighteen:
 
    CMP CENTURY, 19
    JZ Nineteen
    JMP NOT_Nineteen
    Nineteen:
    MOV ANCHOR_DAY, 5
    NOT_Nineteen:
    
    CMP CENTURY, 20
    JZ Twenty
    JMP NOT_Twenty
    Twenty:
    MOV ANCHOR_DAY, 4
    NOT_Twenty:
    
    CMP CENTURY, 21
    JZ Twenty_one
    JMP NOT_Twenty_one
    Twenty_one:
    MOV ANCHOR_DAY, 2
    NOT_Twenty_one:
    
    ;DETECT DOOMSDAY OF YEAR
   
    MOV AL, YEAR
    MOV AH, 00                  ; SURE THAT AH IS CLEAR
    MOV BL, 4
    DIV BL                      ;DIV YEAR BY 4 TO ADD LEAP YEARS
    ADD AL, YEAR                ;ADD THE YAER TO LEAP YEARS AND STORE IN AL
    MOV AH, 00
    MOV BL, 7
    DIV BL                      ;DIV (YEAR + LEAP YEARS) BY 7 TO GET MOD OF 7 (REMAINDER) IN AH
    ADD AH, ANCHOR_DAY          ;ADD REMAINDER + ANCHOR_DAY TO GET THE DOOMSDAY IN REGISTER(AH)
    MOV DOOMSDAY, AH            ;STORE DOOMSDAY IN DOOMSDAY VARIABLE
    
    
    ;DETECT MONTH_INPUT
    
    CMP MONTH_INPUT, 1          ;January
    JZ Jan
    JMP NOT_Jan                 ;OUT IF MONTH_INPUT NOT EQUAL 1
    Jan:
    MOV DX, 00
    MOV AX, YEAR_INPUT
    MOV BX, 4
    DIV BX 
    CMP DX, 00                  ;FIND OUT IF THE INPUT_YEAR IS A LEAP YEAR OR NOT
    JZ LEAP_YEAR1           
    MOV SPECIAL_DAY, 3   
    CALL DETECT_DAY_INPUT
    JMP NOT_Jan
    LEAP_YEAR1:
    MOV SPECIAL_DAY, 4
    CALL DETECT_DAY_INPUT
    NOT_Jan:
    
    CMP MONTH_INPUT, 2          ;FEBRUARY
    JZ Feb
    JMP NOT_Feb
    Feb:
    MOV DX, 00
    MOV AX, YEAR_INPUT
    MOV BX, 4
    DIV BX 
    CMP DX, 00
    JZ LEAP_YEAR2
    MOV SPECIAL_DAY, 28   
    CALL DETECT_DAY_INPUT
    JMP NOT_Feb
    LEAP_YEAR2:
    MOV SPECIAL_DAY, 29
    CALL DETECT_DAY_INPUT
    NOT_Feb:
  
    
    CMP MONTH_INPUT, 3          ;March
    JZ Mar
    JMP NOT_Mar                  
    Mar:
    MOV SPECIAL_DAY,14   
    CALL DETECT_DAY_INPUT
    NOT_Mar:
    
    CMP MONTH_INPUT, 4          ;April
    JZ Apr
    JMP NOT_Apr
    Apr:
    MOV SPECIAL_DAY, 4   
    CALL DETECT_DAY_INPUT
    NOT_Apr:
     
    CMP MONTH_INPUT, 5          ;May
    JZ May
    JMP NOT_May
    May:
    MOV SPECIAL_DAY, 9   
    CALL DETECT_DAY_INPUT
    NOT_May:
        
    CMP MONTH_INPUT, 6          ;June
    JZ Jun
    JMP NOT_Jun
    Jun:
    MOV SPECIAL_DAY, 6   
    CALL DETECT_DAY_INPUT
    NOT_Jun:
    
    CMP MONTH_INPUT, 7          ;July
    JZ Jul
    JMP NOT_Jul
    Jul:
    MOV SPECIAL_DAY, 11   
    CALL DETECT_DAY_INPUT
    NOT_Jul:
    
    CMP MONTH_INPUT, 8          ;August
    JZ Aug
    JMP NOT_Aug
    Aug:
    MOV SPECIAL_DAY, 8      
    CALL DETECT_DAY_INPUT
    NOT_Aug:
    
    CMP MONTH_INPUT, 9          ;September
    JZ Sept
    JMP NOT_Sept
    Sept:
    MOV SPECIAL_DAY, 5   
    CALL DETECT_DAY_INPUT
    NOT_Sept:
    
    CMP MONTH_INPUT, 10         ;October
    JZ Oct
    JMP NOT_Oct
    Oct:
    MOV SPECIAL_DAY, 10  
    CALL DETECT_DAY_INPUT
    NOT_Oct:
    
    CMP MONTH_INPUT, 11         ;November
    JZ Nov
    JMP NOT_Nov
    Nov:
    MOV SPECIAL_DAY, 7   
    CALL DETECT_DAY_INPUT
    NOT_Nov:
    
    CMP MONTH_INPUT, 12         ;December
    JZ December
    JMP NOT_Dec
    December:
    MOV SPECIAL_DAY, 12   
    CALL DETECT_DAY_INPUT
    NOT_Dec:
    
    .EXIT
    MAIN ENDP
    
    PRINT_MSG PROC NEAR
    MOV AH, 09H
    INT 21H
    RET
    PRINT_MSG ENDP
    
    READ_DIGIT PROC NEAR
    MOV AH, 01H
    INT 21H
    MOV AH, 00
    SUB AL, 30H             ;CONVERT ENTERD DIGIT FROM CHARACTER TO DECIMAL
    
    RET
    READ_DIGIT ENDP
    
    
    DETECT_DAY_INPUT PROC NEAR
                                ;DETECT DAY_INPUT
        MOV AL, SPECIAL_DAY
        CMP DAY_INPUT, AL    
        JG ABOVE
        JB BELOW
        ;ADD DOOMSDAY, 0            ;IN CASE THAT DAY_INPUT EQUAL 14
        CALL DOOMSDAY_PRINT
        JMP FINISHED               ;OUT IF IT EQUAL 14
        ABOVE:
            SUB DAY_INPUT, AL
            MOV AH, 00             ;SURE THAT AH IS CLEAR
            MOV AL, DAY_INPUT
            MOV BL, 7
            DIV BL
            ADD DOOMSDAY, AH        ;ADD THE REMAINDER TO DOOMSDAY
            CALL DOOMSDAY_PRINT
        JMP FINISHED    
        BELOW:
            SUB AL,DAY_INPUT
            MOV DAY_INPUT,AL
            MOV AH, 00              ;SURE THAT AH IS CLEAR
            MOV BL, 7
            DIV BL
            SUB DOOMSDAY,AH
            CALL DOOMSDAY_PRINT
        
            FINISHED:
    RET
    DETECT_DAY_INPUT ENDP
    
    DOOMSDAY_PRINT PROC NEAR
    ;CLEAR WEEKS BEFORE PRINT
    MOV AH, 00                      ;SHURE THAT AH IS CLEAR
    MOV AL, DOOMSDAY
    MOV BL, 7
    DIV BL
    CMP AH, 00                      ;AFTER CLEAR WEEKS DAY 7(Friday) BECOME ZERO
    JZ DAY_ZERO         
    JMP SKIP                        ;DON'T ENTER IF DOOMSDAY NOT EQUAL 0
    DAY_ZERO:
    ADD AH, 07                      ;TO CONVERT DAY 0 TO 7 
    SKIP:
    MOV DOOMSDAY, AH
    ;PRINT
    CALL TRANSLATE
    MOV AH, 09
    INT 21H

    RET
    DOOMSDAY_PRINT ENDP
    
    ;TRANSLATE DAY NAMES (FROM NUMBER TO NAMES)
    
    TRANSLATE PROC NEAR
    CMP DOOMSDAY, 1
    JZ Saturday
    JMP NOT_Sat
    Saturday:
    LEA DX, Sat
    NOT_Sat:

    CMP DOOMSDAY, 2
    JZ Sunday
    JMP NOT_Sun
    Sunday:
    LEA DX, Sun
    NOT_Sun:
    
    CMP DOOMSDAY, 3
    JZ Monday
    JMP NOT_Mon
    Monday:
    LEA DX, Mon
    NOT_Mon:
    
    CMP DOOMSDAY, 4
    JZ Tuesday
    JMP NOT_Tue
    Tuesday:
    LEA DX, Tue
    NOT_Tue:
    
    CMP DOOMSDAY, 5
    JZ Wednesday
    JMP NOT_Wed
    Wednesday:
    LEA DX, Wed
    NOT_Wed:
    
    CMP DOOMSDAY, 6
    JZ Thursday
    JMP NOT_Thu
    Thursday:
    LEA DX, Thu
    NOT_Thu:
    
    CMP DOOMSDAY, 7
    JZ Friday
    JMP NOT_Fri
    Friday:
    LEA DX, Fri
    NOT_Fri:

    RET
    TRANSLATE ENDP
    
END MAIN