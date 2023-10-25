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
	MOV	DPL,#0
	MOV	DPH,#0
	MOV	DPP,#8
        ; запись нуля в разряд COL1 регистра KB
	MOV	A,#0FEh
	MOVX	@DPTR,A
        ; считываем регистр KB
	MOVX	A,@DPTR
        ; проверяем наличие нуля в разряде ROW3 регистра KB
        ; (была ли нажата клавиша 7)
	ANL	A,#40h
	JNZ	M1
        ; выводим на дисплей символ N
	MOV	A,#0CFH	;задаёмся знакоместом (правый нижний угол)
	LCALL	CDISP
	MOV	A,#4EH	;указываем код символа N
	LCALL	DISPA
M1:
	; записываем адрес регистра KB (клавиатура)
        ; в регистры указателя данных PDTR
	MOV	DPL,#0
	MOV	DPH,#0
	MOV	DPP,#8
        ; запись нуля в разряд COL2 регистра KB
	MOV	A,#0FDh
	MOVX	@DPTR,A
        ; считываем регистр KB
	MOVX	A,@DPTR
        ; проверяем наличие нуля в разряде ROW1 регистра KB
        ; (была ли нажата клавиша 2)
	ANL	A,#10h
	JNZ	M2
        ; убираем с диплея символ N
	MOV	A,#0CFH	;задаёмся знакоместом (правый нижний угол)
	LCALL	CDISP
	MOV	A,#0
	LCALL	DISPA
M2:
        SJMP START
        
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        SJMP $ ; замкнутый бесконечный цикл
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

        ; XXXXXX - ПОДПРОГРАММЫ - XXXXXX ;

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
;DISPA
;Вывод на ЖКИ одного символа из ACC.
DISPA:
	;Пересылаем символ из регистра ACC в регистр DATA_IND.
	;08 00 01H - адрес регистра данных DATA_IND во внешней памяти.
	MOV	DPP,#8
	MOV	DPH,#0
	MOV	DPL,#1
	MOVX	@DPTR,A
	LCALL	D40MCS
	;Отображаем символ из DATA_IND на текущее знакоместо ЖКИ.
	;08 00 06H - адрес регистра управления С_IND во внешней памяти.
	;#0DH и #0CH - управляющие коды, последовательная смена которых
	;инициирует пересылку символа из DATA_IND в видеопамять DDRAM.
	MOV	DPL,#6
	MOV	A,#0DH
	MOVX	@DPTR,A
	LCALL	D40MCS
	MOV	A,#0CH
	MOVX	@DPTR,A
	LCALL	D40MCS
	RET

;СDISP
;Отправка команды из ACC для ЖКИ.
CDISP:
	;Пересылаем команду из регистра ACC в регистр DATA_IND.
	;08 00 01H - адрес регистра данных DATA_IND во внешней памяти.
	MOV	DPP,#8
	MOV	DPH,#0
	MOV	DPL,#1
	MOVX	@DPTR,A
	LCALL	D2MS
	;Активируем команду из DATA_IND для ЖКИ.
	;08 00 06H - адрес регистра управления С_IND во внешней памяти.
	;#9 и #8 - управляющие коды, последовательная смена которых
	;активирует команду в DATA_IND для ЖКИ.
	MOV	DPL,#6
	MOV	A,#9
	MOVX	@DPTR,A
	LCALL	D40MCS
	MOV	A,#8
	MOVX	@DPTR,A
	LCALL	D40MCS
	RET

;D40MCS
;Задержка 40 мкс.
D40MCS:
	MOV	R0,#25
	DJNZ	R0,$
	RET

;D2MS
;Задержка 2 мс.
D2MS:
	MOV	R1,#10
D2MS1:
	MOV	R0,#138
D2MS0:
	DJNZ	R0,D2MS0
	DJNZ	R1,D2MS1
	RET
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        END ; обязательный признак завершения текста
