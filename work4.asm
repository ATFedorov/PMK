; 2023 ОТИ МИФИ
; Учебная группа: 1ПО-40Д
; Дисциплина: Программирование микроконтроллеров
; Микроконтроллер: учебный стенд SDK 1.1
; Студент: Федоров А.Т.

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
CALWR	EQU	0A0h		;байт адреса календаря при записи
CALRD	EQU	0A1h		;байт адреса календаря при чтении
I2CACK	EQU	0		;временный хранитель бита подтверждения
	
	;Инициализируем календарь.
	MOV	I2CCON,#0C8h	;мастер-режим, SCL = 0, SDA = 1
	LCALL	D6MCS
	LCALL	I2CSTART
	MOV	A,#CALWR	;запись в устройство
	LCALL	I2CPUTA
	JC	ERR
	LCALL	I2CSTOP
	
;Выводим дату на дисплей.
DISPLAY_DATE:
	LCALL	CAL_DATE_READ
	LCALL	PRINT_DATE
	
CHECK_BUTTON_1:
	;Записываем адрес регистра KB (клавиатура)
        ;в регистры указателя данных PDTR.
	MOV	DPL,#0
	MOV	DPH,#0
	MOV	DPP,#8
        ;Запись нуля в разряд COL1 регистра KB.
	MOV	A,#0FEh
	MOVX	@DPTR,A
        ;Считываем регистр KB.
	MOVX	A,@DPTR
        ;Проверяем наличие нуля в разряде ROW1 регистра KB
        ;(была ли нажата клавиша 1).
	ANL	A,#10h
	JNZ	CHECK_BUTTON_2
        ;Увеличиваем дату на 1.
	LCALL	CAL_DATE_READ
	INC	A
	LCALL	DAA
	PUSH	ACC
	LCALL	CAL_DATE_WRITE
	;Обновляем дату на экране.
	POP	ACC
	LCALL	PRINT_DATE
CHECK_BUTTON_2:
	;Записываем адрес регистра KB (клавиатура)
        ;в регистры указателя данных PDTR.
	MOV	DPL,#0
	MOV	DPH,#0
	MOV	DPP,#8
        ;Запись нуля в разряд COL2 регистра KB.
	MOV	A,#0FDh
	MOVX	@DPTR,A
        ;Считываем регистр KB.
	MOVX	A,@DPTR
        ;Проверяем наличие нуля в разряде ROW1 регистра KB
        ;(была ли нажата клавиша 2).
	ANL	A,#10h
	JNZ	END_CHECK_BUTTONS
        ;Уменьшаем дату на 2.
	LCALL	CAL_DATE_READ
	DEC	A
	DEC	A
	LCALL	DAS
	PUSH	ACC
	LCALL	CAL_DATE_WRITE
	;Обновляем дату на экране.
	POP	ACC
	LCALL	PRINT_DATE
END_CHECK_BUTTONS:
        SJMP CHECK_BUTTON_1
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
;ERR
;Бит подтверждения не получен.
ERR:
        SJMP $ ; замкнутый бесконечный цикл
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

        ; XXXXXX - ПОДПРОГРАММЫ - XXXXXX ;

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
;CAL_DATE_READ
;Читает дату из календаря.
;[out] ACC : дата
CAL_DATE_READ:
	LCALL	I2CSTART
	MOV	A,#CALWR
	LCALL	I2CPUTA
	JC	ERR
	MOV	A,#5		;адрес регистра с годом/датой
	LCALL	I2CPUTA
	JC	ERR
	LCALL	I2CSTART	;рестарт
	MOV	A,#CALRD	;чтение устройства
	LCALL	I2CPUTA
	JC	ERR
	LCALL	I2CGETA
	MOV	R1,A
	LCALL	I2CSETK1
	LCALL	I2CSTOP
	MOV	A,R1
	RET

;CAL_DATE_WRITE
;Записывает дату в календарь.
;[in] ACC : дата
CAL_DATE_WRITE:
	MOV	R1,A
	LCALL	I2CSTART
	MOV	A,#CALWR
	LCALL	I2CPUTA
	JC	ERR
	MOV	A,#5		;адрес регистра с годом/датой
	LCALL	I2CPUTA
	JC	ERR
	MOV	A,R1
	LCALL	I2CPUTA
	JC	ERR
	LCALL	I2CSTOP
	RET

;PRINT_DATE
;Печатает дату на дисплее.
PRINT_DATE:
	MOV	R7,A		;сохраняем дату
	SWAP	A
	ANL	A,#00000011B
	ADD	A,#30H
	MOV	R6,A		;старшая цифра даты -> R6
	MOV	A,R7
	ANL	A,#00001111B
	ADD	A,#30H
	MOV	R5,A		;младшая цифра даты -> R5
	;Выводим на дисплей старшую цифру даты.
	MOV	A,#80H	;задаёмся знакоместом
	LCALL	CDISP
	MOV	A,R6	;код старшей цифры
	LCALL	DISPA
	;Выводим на дисплей младшую цифру даты.
	MOV	A,#81H	;задаёмся знакоместом
	LCALL	CDISP
	MOV	A,R5	;код младшей цифры
	LCALL	DISPA
	RET

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

;I2CSTART
;Стартовый сигнал интерфейса I2C.
I2CSTART:
	SETB	MDO		;SDA = 1
	LCALL	D6MCS
	SETB	MCO		;SCL = 1
	LCALL	D6MCS
	CLR	MDO		;SDA = 0
	LCALL	D6MCS
	CLR	MCO		;SCL = 0
	LCALL	D6MCS
	RET
	
;I2CSTOP
;Стоповый сигнал интерфейса I2C.
I2CSTOP:
	CLR	MDO		;SDA = 0
	LCALL	D6MCS
	SETB	MCO		;SCL = 1
	LCALL	D6MCS
	SETB	MDO		;SDA = 1
	LCALL	D6MCS
	CLR	MCO		;SCL = 0
	LCALL	D6MCS
	RET
	
;I2CPUTA
;Запись байта в устройство через интерфейс I2C.
;[in] ACC : байт, который нужно записать в устройство
;[out] CY : бит подстверждения от устройства
I2CPUTA:
	MOV	R6,#8
I2CPUTA1:
	RLC	A		;бит 7 -> CY
	MOV	MDO,C		;SDA = CY
	LCALL	D6MCS
	SETB	MCO		;SCL = 1
	LCALL	D6MCS
	CLR	MCO		;SCL = 0
	LCALL	D6MCS
	DJNZ	R6,I2CPUTA1
	;Получим подтверждение.
	CLR	MDE
	LCALL	D6MCS
	SETB	MCO		;SCL = 1
	LCALL	D6MCS
	MOV	C,MDI		;чтение SDA
	MOV	I2CACK,C
	LCALL	D6MCS
	CLR	MCO		;SCL = 0
	LCALL	D6MCS
	SETB	MDE
	MOV	C,I2CACK
	RET
	
;I2CGETA
;Читает байт, переданный устройством, с линии интерфейса I2C.
;[out] ACC : байт, переданный устройством
I2CGETA:
	MOV	R6,#8
	CLR	MDE
I2CGETA1:
	SETB	MCO		;SCL = 1
	LCALL	D6MCS
	MOV	C,MDI		;чтение SDA
	RLC	A		;ACC <- CR
	CLR	MCO		;SCL = 0
	LCALL	D6MCS
	DJNZ	R6,I2CGETA1
	SETB	MDE
	RET
	
;I2CSETK0
;Подтверждение мастера 0.
I2CSETK0:
	CLR	MDO		;SDA = 0
	LCALL	D6MCS
	SETB	MCO		;SCL = 1
	LCALL	D6MCS
	CLR	MCO		;SCL = 0
	LCALL	D6MCS
	RET
	
;I2CSETK1
;Подтверждение мастера 1.
I2CSETK1:
	SETB	MDO		;SDA = 1
	LCALL	D6MCS
	SETB	MCO		;SCL = 1
	LCALL	D6MCS
	CLR	MCO		;SCL = 0
	LCALL	D6MCS
	RET
	
;D6MCS
;Задержка 6 мкс.
D6MCS:
	MOV	R0,#1
	DJNZ	R0,$
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
	
;DAA
;Десятичная коррекция при сложении
;(корректирует только младшую тетраду).
;[in] ACC : двоично-десятичное число, требующее коррекции
;[out] ACC : скорректированное двооично-десятичное число
DAA:
	MOV	R7,A
	ANL	A,#0FH		;младшая тетрада
	CLR	C
	SUBB	A,#0AH
	MOV	A,R7
	JC	EXIT_DAA
	ADD	A,#06H
EXIT_DAA:
	RET
	
;DAS
;Десятичная коррекция при вычитании
;(корректирует только младшую тетраду).
;[in] ACC : двоично-десятичное число, требующее коррекции
;[out] ACC : скорректированное двооично-десятичное число
DAS:
	MOV	R7,A
	ANL	A,#0FH		;младшая тетрада
	CLR	C
	SUBB	A,#0AH
	MOV	A,R7
	JC	EXIT_DAS
	SUBB	A,#06H
EXIT_DAS:
	RET
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        END ; обязательный признак завершения текста
