Page 60, 132
Title Ejemplo CALL y RET
;include macros.inc
potencia macro base, pote, resultado
	mov dx,pote
	push base
	push resultado
	call pot
	pop resultado
	pop ax
	pop ax
	xor ax,ax		
endm
multiplica macro mul1, mul2, resultado
	mov dx,mul1
	push mul2
	push dx
	mov ax,offset resultado
	push ax
	call multi; el resultado queda en el parámetro resultado	
endm
factorial macro numFac, resultado
	mov dx,numFac
	push dx
	call fact
	pop resultado
endm
suma macro sum1, sum2, resultado
	mov ax,offset resultado
	mov bx,offset sum1
	mov cx,offset sum2
	push ax
	push bx
	push cx
	call sum	
endm
.model small
.stack 64
.data
X  dw  00
Y  dw  00
Z  dw  02
TMP  dw  00
.code
Principal proc
	mov ax, @data
	mov ds, ax
	mov es, ax
	potencia z, 03, X ;calculando z^3 = X	
	potencia X, 02, tmp	; calculando X^2	
	multiplica 02, tmp, tmp ; el resultado queda en tmp -> 2 * X ^ 2	
	suma tmp, Y, tmp ; --> tmp = 2 * X ^ 2 ;
	mov ax,tmp
	mov Y,ax; ; --> Y = 2 * X ^ 2 ; asignando la suma a Y	
	; calculando 2 * X
	multiplica 02, X, tmp; el resultado queda en tmp -> 2 * X	
	; realizar la suma de lo que ya hay en Y
	suma tmp,Y,Y; Y = 2 * X ^ 2 + 2 * X	
	factorial 05,tmp; resultado del factorial a tmp
	suma tmp,Y,Y; Y = 2 * X ^ 2 + 2 * X + 5!			
	mov ah,04ch
	mov al,0
	int 21h
Principal  endp
	POT  proc
		mov bp, sp		
		mov ax, 01
		add bp,06
		mov bx, [bp]   ; bx=z
		sub bp,02	
		mov cx, [bp]  ;[dx]=potencia
	et1:
		mul bl
		loop et1
		sub bp, 2
		mov [bp], ax
		ret
	POT endp
	MULTI proc
		mov bp,sp
		add bp,06
		mov ax,[bp]; 1 multiplicando
		sub bp,02
		mov bx,[bp];
		mul bl ; multiplicación
		sub bp,02
		mov si,[bp]
		mov [si],ax
		ret 6		
	MULTI endp
	SUM proc
		mov bp,sp
		add bp,06
		mov si,[bp]; dir de tmp a si
		mov ax,[si]; obteniendo el contenido de tmp y pasandolo a ax
		sub bp,02; 
		mov si,[bp]; obteniendo dir de Y
		add ax,[si]; sumando a ax el contenido de Y
		sub bp,02; 
		mov si,[bp]; dir de var donde va a quedar la suma
		mov [si],ax; asignando valor de la suma
		ret 6				
	SUM endp
	FACT proc
		mov bp,sp
		dec bp
		dec bp
		mov cx,[bp]
		mov al,1
	et2:
		mul cl
		loop et2
		mov [bp],ax
		ret
	FACT endp
end Principal
