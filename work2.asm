; 2017 ОТИ МИФИ
; Учебная группа 1ПО-44Д
; Дисциплина: Программирование микроконтроллеров
; Микроконтроллер: учебный стенд SDK 1.1
;

$Mod812 ; включаем файл, содержащий символы микроконтроллера
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
; здесь располагаются символы, определяемые программистом


; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        LJMP START ; переход на начало программы
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        
        ; здесь располагаются обработчики прерываний
        
        
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        ORG 80h ; адрес начала программы
START:  ; метка начала программы
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

        ; здесь располагаются инструкции алгоритма программы
        ; иначе говоря, основной код пишем здесь !!!
        ; записываем адрес регистра KB (клавиатура)
        ; в регистры указателя данных PDTR
        MOV DPL,#0
        MOV DPH,#0
        MOV DPP,#8
        ; запись нуля в разряд COL1 регистра KB
        MOV A,#0FEh
        MOVX @DPTR,A
        ; считываем регистр KB
        MOVX A,@DPTR
        ; проверяем наличие нуля в разряде ROW2 регистра KB
        ; (была ли нажата клавиша 4)
        PUSH ACC
        ANL A,#020h
        JNZ M1
        LCALL LIGHTOFF
M1:
        POP ACC
        ; проверяем наличие нуля в разряде ROW3 регистра KB
        ; (была ли нажата клавиша 7)
        ANL A,#040h
        JNZ M2
        LCALL LIGHTON
M2:
        SJMP START
        
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        SJMP $ ; замкнутый бесконечный цикл
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

        ; XXXXXX - ПОДПРОГРАММЫ - XXXXXX ;

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
; LIGHTON: включаем крайние светодиоды (0 и 7)
LIGHTON:
        ; записываем адрес регистра линейки светодиодов
        ; в регистры указателя данных PDTR
        MOV DPL,#7
        MOV DPH,#0
        MOV DPP,#8
        ; включаем светодиоды 0 и 7, остальные выключаем
        MOV A,#081h
        MOVX @DPTR,A
        RET
        
; LIGHTOFF: гасим все светодиоды
LIGHTOFF:
        ; записываем адрес регистра линейки светодиодов
        ; в регистры указателя данных PDTR
        MOV DPL,#7
        MOV DPH,#0
        MOV DPP,#8
        ; выключаем все светодиоды
        MOV A,#0
        MOVX @DPTR,A
        RET
        
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        END ; обязательный признак завершения текста
