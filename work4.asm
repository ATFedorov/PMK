; 2023 ��� ����
; ������� ������: 1��-40�
; ����������: ���������������� �����������������
; ���������������: ������� ����� SDK 1.1
; �������: ������� �.�.

$Mod812 ; �������� ����, ���������� ������� ����������������
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
; ����� ������������� �������, ������������ �������������


; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        LJMP START ; ������� �� ������ ���������
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        
        ; ����� ������������� ����������� ����������
        
        
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        ORG 80h ; ����� ������ ���������
START:  ; ����� ������ ���������
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
CALWR	EQU	0A0h		;���� ������ ��������� ��� ������
CALRD	EQU	0A1h		;���� ������ ��������� ��� ������
I2CACK	EQU	0		;��������� ��������� ���� �������������
	
	;�������������� ���������.
	MOV	I2CCON,#0C8h	;������-�����, SCL = 0, SDA = 1
	LCALL	D6MCS
	LCALL	I2CSTART
	MOV	A,#CALWR	;������ � ����������
	LCALL	I2CPUTA
	JC	ERR
	LCALL	I2CSTOP
	
;������� ���� �� �������.
DISPLAY_DATE:
	LCALL	CAL_DATE_READ
	LCALL	PRINT_DATE
	
CHECK_BUTTON_1:
	;���������� ����� �������� KB (����������)
        ;� �������� ��������� ������ PDTR.
	MOV	DPL,#0
	MOV	DPH,#0
	MOV	DPP,#8
        ;������ ���� � ������ COL1 �������� KB.
	MOV	A,#0FEh
	MOVX	@DPTR,A
        ;��������� ������� KB.
	MOVX	A,@DPTR
        ;��������� ������� ���� � ������� ROW1 �������� KB
        ;(���� �� ������ ������� 1).
	ANL	A,#10h
	JNZ	CHECK_BUTTON_2
        ;����������� ���� �� 1.
	LCALL	CAL_DATE_READ
	INC	A
	LCALL	DAA
	PUSH	ACC
	LCALL	CAL_DATE_WRITE
	;��������� ���� �� ������.
	POP	ACC
	LCALL	PRINT_DATE
CHECK_BUTTON_2:
	;���������� ����� �������� KB (����������)
        ;� �������� ��������� ������ PDTR.
	MOV	DPL,#0
	MOV	DPH,#0
	MOV	DPP,#8
        ;������ ���� � ������ COL2 �������� KB.
	MOV	A,#0FDh
	MOVX	@DPTR,A
        ;��������� ������� KB.
	MOVX	A,@DPTR
        ;��������� ������� ���� � ������� ROW1 �������� KB
        ;(���� �� ������ ������� 2).
	ANL	A,#10h
	JNZ	END_CHECK_BUTTONS
        ;��������� ���� �� 2.
	LCALL	CAL_DATE_READ
	DEC	A
	DEC	A
	LCALL	DAS
	PUSH	ACC
	LCALL	CAL_DATE_WRITE
	;��������� ���� �� ������.
	POP	ACC
	LCALL	PRINT_DATE
END_CHECK_BUTTONS:
        SJMP CHECK_BUTTON_1
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
;ERR
;��� ������������� �� �������.
ERR:
        SJMP $ ; ��������� ����������� ����
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

        ; XXXXXX - ������������ - XXXXXX ;

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
;CAL_DATE_READ
;������ ���� �� ���������.
;[out] ACC : ����
CAL_DATE_READ:
	LCALL	I2CSTART
	MOV	A,#CALWR
	LCALL	I2CPUTA
	JC	ERR
	MOV	A,#5		;����� �������� � �����/�����
	LCALL	I2CPUTA
	JC	ERR
	LCALL	I2CSTART	;�������
	MOV	A,#CALRD	;������ ����������
	LCALL	I2CPUTA
	JC	ERR
	LCALL	I2CGETA
	MOV	R1,A
	LCALL	I2CSETK1
	LCALL	I2CSTOP
	MOV	A,R1
	RET

;CAL_DATE_WRITE
;���������� ���� � ���������.
;[in] ACC : ����
CAL_DATE_WRITE:
	MOV	R1,A
	LCALL	I2CSTART
	MOV	A,#CALWR
	LCALL	I2CPUTA
	JC	ERR
	MOV	A,#5		;����� �������� � �����/�����
	LCALL	I2CPUTA
	JC	ERR
	MOV	A,R1
	LCALL	I2CPUTA
	JC	ERR
	LCALL	I2CSTOP
	RET

;PRINT_DATE
;�������� ���� �� �������.
PRINT_DATE:
	MOV	R7,A		;��������� ����
	SWAP	A
	ANL	A,#00000011B
	ADD	A,#30H
	MOV	R6,A		;������� ����� ���� -> R6
	MOV	A,R7
	ANL	A,#00001111B
	ADD	A,#30H
	MOV	R5,A		;������� ����� ���� -> R5
	;������� �� ������� ������� ����� ����.
	MOV	A,#80H	;������� �����������
	LCALL	CDISP
	MOV	A,R6	;��� ������� �����
	LCALL	DISPA
	;������� �� ������� ������� ����� ����.
	MOV	A,#81H	;������� �����������
	LCALL	CDISP
	MOV	A,R5	;��� ������� �����
	LCALL	DISPA
	RET

;DISPA
;����� �� ��� ������ ������� �� ACC.
DISPA:
	;���������� ������ �� �������� ACC � ������� DATA_IND.
	;08 00 01H - ����� �������� ������ DATA_IND �� ������� ������.
	MOV	DPP,#8
	MOV	DPH,#0
	MOV	DPL,#1
	MOVX	@DPTR,A
	LCALL	D40MCS
	;���������� ������ �� DATA_IND �� ������� ���������� ���.
	;08 00 06H - ����� �������� ���������� �_IND �� ������� ������.
	;#0DH � #0CH - ����������� ����, ���������������� ����� �������
	;���������� ��������� ������� �� DATA_IND � ����������� DDRAM.
	MOV	DPL,#6
	MOV	A,#0DH
	MOVX	@DPTR,A
	LCALL	D40MCS
	MOV	A,#0CH
	MOVX	@DPTR,A
	LCALL	D40MCS
	RET

;�DISP
;�������� ������� �� ACC ��� ���.
CDISP:
	;���������� ������� �� �������� ACC � ������� DATA_IND.
	;08 00 01H - ����� �������� ������ DATA_IND �� ������� ������.
	MOV	DPP,#8
	MOV	DPH,#0
	MOV	DPL,#1
	MOVX	@DPTR,A
	LCALL	D2MS
	;���������� ������� �� DATA_IND ��� ���.
	;08 00 06H - ����� �������� ���������� �_IND �� ������� ������.
	;#9 � #8 - ����������� ����, ���������������� ����� �������
	;���������� ������� � DATA_IND ��� ���.
	MOV	DPL,#6
	MOV	A,#9
	MOVX	@DPTR,A
	LCALL	D40MCS
	MOV	A,#8
	MOVX	@DPTR,A
	LCALL	D40MCS
	RET

;I2CSTART
;��������� ������ ���������� I2C.
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
;�������� ������ ���������� I2C.
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
;������ ����� � ���������� ����� ��������� I2C.
;[in] ACC : ����, ������� ����� �������� � ����������
;[out] CY : ��� �������������� �� ����������
I2CPUTA:
	MOV	R6,#8
I2CPUTA1:
	RLC	A		;��� 7 -> CY
	MOV	MDO,C		;SDA = CY
	LCALL	D6MCS
	SETB	MCO		;SCL = 1
	LCALL	D6MCS
	CLR	MCO		;SCL = 0
	LCALL	D6MCS
	DJNZ	R6,I2CPUTA1
	;������� �������������.
	CLR	MDE
	LCALL	D6MCS
	SETB	MCO		;SCL = 1
	LCALL	D6MCS
	MOV	C,MDI		;������ SDA
	MOV	I2CACK,C
	LCALL	D6MCS
	CLR	MCO		;SCL = 0
	LCALL	D6MCS
	SETB	MDE
	MOV	C,I2CACK
	RET
	
;I2CGETA
;������ ����, ���������� �����������, � ����� ���������� I2C.
;[out] ACC : ����, ���������� �����������
I2CGETA:
	MOV	R6,#8
	CLR	MDE
I2CGETA1:
	SETB	MCO		;SCL = 1
	LCALL	D6MCS
	MOV	C,MDI		;������ SDA
	RLC	A		;ACC <- CR
	CLR	MCO		;SCL = 0
	LCALL	D6MCS
	DJNZ	R6,I2CGETA1
	SETB	MDE
	RET
	
;I2CSETK0
;������������� ������� 0.
I2CSETK0:
	CLR	MDO		;SDA = 0
	LCALL	D6MCS
	SETB	MCO		;SCL = 1
	LCALL	D6MCS
	CLR	MCO		;SCL = 0
	LCALL	D6MCS
	RET
	
;I2CSETK1
;������������� ������� 1.
I2CSETK1:
	SETB	MDO		;SDA = 1
	LCALL	D6MCS
	SETB	MCO		;SCL = 1
	LCALL	D6MCS
	CLR	MCO		;SCL = 0
	LCALL	D6MCS
	RET
	
;D6MCS
;�������� 6 ���.
D6MCS:
	MOV	R0,#1
	DJNZ	R0,$
	RET
	
;D40MCS
;�������� 40 ���.
D40MCS:
	MOV	R0,#25
	DJNZ	R0,$
	RET

;D2MS
;�������� 2 ��.
D2MS:
	MOV	R1,#10
D2MS1:
	MOV	R0,#138
D2MS0:
	DJNZ	R0,D2MS0
	DJNZ	R1,D2MS1
	RET
	
;DAA
;���������� ��������� ��� ��������
;(������������ ������ ������� �������).
;[in] ACC : �������-���������� �����, ��������� ���������
;[out] ACC : ����������������� ��������-���������� �����
DAA:
	MOV	R7,A
	ANL	A,#0FH		;������� �������
	CLR	C
	SUBB	A,#0AH
	MOV	A,R7
	JC	EXIT_DAA
	ADD	A,#06H
EXIT_DAA:
	RET
	
;DAS
;���������� ��������� ��� ���������
;(������������ ������ ������� �������).
;[in] ACC : �������-���������� �����, ��������� ���������
;[out] ACC : ����������������� ��������-���������� �����
DAS:
	MOV	R7,A
	ANL	A,#0FH		;������� �������
	CLR	C
	SUBB	A,#0AH
	MOV	A,R7
	JC	EXIT_DAS
	SUBB	A,#06H
EXIT_DAS:
	RET
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        END ; ������������ ������� ���������� ������
