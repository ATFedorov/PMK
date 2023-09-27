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
        MOV DPL,#7
        MOV DPH,#0
        MOV DPP,#8
CYCLE:
        MOV A,#18h      ; включаем два средних светодиода (LED 3 и LED 4)
        MOVX @DPTR,A
        LCALL DELAY3021 ; вызываем подпрограмму задержки на 3 с
        CLR A           ; выключаем все светодиоды
        MOVX @DPTR,A
        LCALL DELAY3021 ; вызываем подпрограмму задержки на 3 с
        SJMP CYCLE      ; зацикливаем анимацию
        
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        SJMP $ ; замкнутый бесконечный цикл
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

        ; XXXXXX - ПОДПРОГРАММЫ - XXXXXX ;

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
; подпрограмма задержки на 3021 мс
DELAY3021:
        MOV     R2, #32
D5172:
        MOV     R1, #256
D5171:
        MOV     R0, #0
        DJNZ    R0, $
        DJNZ    R1, D5171
        DJNZ    R2, D5172
        RET ; обязательный признак завершения подпрограммы
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        END ; обязательный признак завершения текста
