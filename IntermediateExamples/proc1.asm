Page 60, 132
Title Ejemplo CALL y RET
.model small
.stack 64
.data
X  dw  00
Y  dw  00
Z  dw  02
TMP  dw  00
.code
Principal   proc far
	mov ax, @data
	mov ds, ax
	mov es, ax
	mov dx, 03
	push z
	push dx
	push tmp
	call pot
	pop x ; guardando valor de la potencia
	pop ax;limpiando stack
	pop ax
	xor ax,ax ; limpiando registro
	; calculando X^2
	mov dx,02
	push x
	push dx
	push tmp
	call pot
	pop tmp
	pop ax
	pop ax
	xor ax,ax
	; calculando 2 * X^2
	mov dx,02
	push tmp
	push dx
	mov ax,offset tmp
	push ax
	call multi ; el resultado queda en tmp -> 2 * X ^ 2
	mov ax,offset tmp
	mov bx,offset Y
	push ax; dir tmp resultado
	push bx; dir Y 1er sumando
	push ax; dir tmp 2do sumando
	call sum
	mov ax,tmp; tmp contiene el valor de la suma
	mov Y,ax; --> Y = 2 * X ^ 2 ; asignando la suma a Y
	; calculando 2 * X
	mov dx,02
	push x
	push dx
	mov ax,offset tmp
	push ax
	call multi ; el resultado queda en tmp -> 2 * X
	; realizar la suma de lo que ya hay en Y
	mov ax,offset tmp
	mov bx,offset Y
	push bx
	push bx
	push ax
	call sum; Y = 2 * X ^ 2 + 2 * X
	mov dx,05
	push dx
	call fact
	pop tmp; resultado del factorial a tmp
	mov ax,offset tmp
	mov bx,offset Y
	push bx
	push bx
	push ax
	call sum ; Y = 2 * X ^ 2 + 2 * X + 5!		
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
