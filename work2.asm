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
        MOV DPL,#0
        MOV DPH,#0
        MOV DPP,#8
        ; ������ ���� � ������ COL1 �������� KB
        MOV A,#0FEh
        MOVX @DPTR,A
        ; ��������� ������� KB
        MOVX A,@DPTR
        ; ��������� ������� ���� � ������� ROW2 �������� KB
        ; (���� �� ������ ������� 4)
        PUSH ACC
        ANL A,#020h
        JNZ M1
        LCALL LIGHTOFF
M1:
        POP ACC
        ; ��������� ������� ���� � ������� ROW3 �������� KB
        ; (���� �� ������ ������� 7)
        ANL A,#040h
        JNZ M2
        LCALL LIGHTON
M2:
        SJMP START
        
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        SJMP $ ; ��������� ����������� ����
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

        ; XXXXXX - ������������ - XXXXXX ;

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
; LIGHTON: �������� ������� ���������� (0 � 7)
LIGHTON:
        ; ���������� ����� �������� ������� �����������
        ; � �������� ��������� ������ PDTR
        MOV DPL,#7
        MOV DPH,#0
        MOV DPP,#8
        ; �������� ���������� 0 � 7, ��������� ���������
        MOV A,#081h
        MOVX @DPTR,A
        RET
        
; LIGHTOFF: ����� ��� ����������
LIGHTOFF:
        ; ���������� ����� �������� ������� �����������
        ; � �������� ��������� ������ PDTR
        MOV DPL,#7
        MOV DPH,#0
        MOV DPP,#8
        ; ��������� ��� ����������
        MOV A,#0
        MOVX @DPTR,A
        RET
        
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        END ; ������������ ������� ���������� ������
