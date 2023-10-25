; 2017 ��� ����
; ������� ������ 1��-44�
; ����������: ���������������� �����������������
; ���������������: ������� ����� SDK 1.1
;

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

        ; ����� ������������� ���������� ��������� ���������
        ; ����� ������, �������� ��� ����� ����� !!!
        ; ���������� ����� �������� KB (����������)
        ; � �������� ��������� ������ PDTR
	MOV	DPL,#0
	MOV	DPH,#0
	MOV	DPP,#8
        ; ������ ���� � ������ COL1 �������� KB
	MOV	A,#0FEh
	MOVX	@DPTR,A
        ; ��������� ������� KB
	MOVX	A,@DPTR
        ; ��������� ������� ���� � ������� ROW3 �������� KB
        ; (���� �� ������ ������� 7)
	ANL	A,#40h
	JNZ	M1
        ; ������� �� ������� ������ N
	MOV	A,#0CFH	;������� ����������� (������ ������ ����)
	LCALL	CDISP
	MOV	A,#4EH	;��������� ��� ������� N
	LCALL	DISPA
M1:
	; ���������� ����� �������� KB (����������)
        ; � �������� ��������� ������ PDTR
	MOV	DPL,#0
	MOV	DPH,#0
	MOV	DPP,#8
        ; ������ ���� � ������ COL2 �������� KB
	MOV	A,#0FDh
	MOVX	@DPTR,A
        ; ��������� ������� KB
	MOVX	A,@DPTR
        ; ��������� ������� ���� � ������� ROW1 �������� KB
        ; (���� �� ������ ������� 2)
	ANL	A,#10h
	JNZ	M2
        ; ������� � ������ ������ N
	MOV	A,#0CFH	;������� ����������� (������ ������ ����)
	LCALL	CDISP
	MOV	A,#0
	LCALL	DISPA
M2:
        SJMP START
        
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        SJMP $ ; ��������� ����������� ����
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

        ; XXXXXX - ������������ - XXXXXX ;

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
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
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        END ; ������������ ������� ���������� ������
