Page 60,132
Title EjemploCallyRet 
.model small 
.stack 64 
.data 
X dw 00
Y dw 00
Z dw 02 
tmp dw 00 
.code 
Principal proc far
	mov ax,@data 
	mov ds,ax 
	mov es,ax 
	
	mov dx,03
	push z 
	push dx 
	push tmp 
	call pot
	pop x; guardando el valor de la potencia x = lo que tiene bp 
	pop ax; limpiando stack 
	pop ax 
	xor ax,ax; limpiando registro 
	; calculando X*X
	mov dx,02
	push x 
	push dx 
	push tmp 
	call pot 
	pop tmp; tmp = X*X 
	pop ax 
	pop ax 
	xor ax,ax 
	;calculando 2 * (X*X)
	mov dx,02 
	push tmp 
	push dx 
	;paso por referencia 
	mov ax,offset tmp 
	push ax 
	call multi ; el resultado queda en tmp 
	mov ax, offset tmp 
	mov bx, offset Y 
	push ax ; dir tmp resultado 
	push bx ; dir Y 1er sumando 
	push ax ; dir tmp 2do sumando 
	call sum 
	mov ax,tmp; tmp contiene el valor de la suma  
	mov Y,ax ; --> Y = 2 * (X*X); asignando la suma a Y 
	;calculando 2 * X 
	mov dx,02 
	push x 
	push dx 
	mov ax,offset tmp 
	push ax 
	call multi
		
Principal endp 
	pot proc 
		mov bp,sp
		mov ax,01
		add bp,06
		mov bx,[bp]; bx = z
		sub bp,02
		mov cx,[bp]; cx = 3
		et1:
			mul bl
			loop et1 
		sub bp2
		mov [bp],ax ; bp=z*z*z
		ret 
	pot endp 
	multi proc
		mov bp,sp
		add bp,06 
		mov ax,[bp]
		sub bp,02 
		mov bx,[bp]
		mul bl 
		sub bp,02 
		mov si,[bp]
		mov [si],ax 
		ret 6
	multi endp
	sum proc 
		mov bp,sp
		add bp,06 
		mov si,[bp]
		mov ax,[si]
		sub bp,02 
		mov si,[bp]
		add ax,[si]
		sub bp,02
		mov si,[bp]
		mov [si],ax 
		ret 6
	sum endp 
end Principal
	
	




















	
	