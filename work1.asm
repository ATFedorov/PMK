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
        MOV DPL,#7
        MOV DPH,#0
        MOV DPP,#8
CYCLE:
        MOV A,#18h      ; �������� ��� ������� ���������� (LED 3 � LED 4)
        MOVX @DPTR,A
        LCALL DELAY3021 ; �������� ������������ �������� �� 3 �
        CLR A           ; ��������� ��� ����������
        MOVX @DPTR,A
        LCALL DELAY3021 ; �������� ������������ �������� �� 3 �
        SJMP CYCLE      ; ����������� ��������
        
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        SJMP $ ; ��������� ����������� ����
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

        ; XXXXXX - ������������ - XXXXXX ;

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
; ������������ �������� �� 3021 ��
DELAY3021:
        MOV     R2, #32
D5172:
        MOV     R1, #256
D5171:
        MOV     R0, #0
        DJNZ    R0, $
        DJNZ    R1, D5171
        DJNZ    R2, D5172
        RET ; ������������ ������� ���������� ������������
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        END ; ������������ ������� ���������� ������
