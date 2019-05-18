Page 60,132
Title Procedimientos 
.model small 
.stack 64 
.data 
X dw 00
Y dw 00
Z dw 02 
TMP dw 00 
resultado db '----','$'
.code 
InicioPrograma:
	;resuelve segmento de datos 
	mov ax,@data
	mov ds,ax 
	mov es,ax
	;
	mov dx,03
	push Z 
	push dx 
	push TMP 
	call POT 
	;imprimir el resultado final
	lea si,resultado
	inc si 
	mov bx,00
	mov bx,[Z]
	mov [si],bx
	mov dx, offset resultado
	inc dx 
	mov ah,09
	int 21h
FinPrograma:
	mov ah,04Ch
	int 21h
POT proc 
	mov bp,sp
	mov bx,00
	mov ax,01
	mov bx,[bp+3]
	mov cx,[bp+2]
potencia: mul bx 
	loop potencia
	mov [Z],ax
	ret 
POT endp 
end	