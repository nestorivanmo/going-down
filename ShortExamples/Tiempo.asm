Title Imprime el reloj de sistema en tiempo real

.model small 

.stack 32

.data
posx db 35
posy db 5
temp db 10
cadtiempo db 11, '  :  :  :  ','$'

;cadfecha db '              ','$'

.code
Start:
	mov ax, @data
	mov ds, ax
	MOV AH,0FH;		limpia pantalla
	INT 10H
	MOV AH,0
	INT 10H
	;mov ah,06
	;mov al,0
	;mov cx,00
	;mov dh,47
	;mov dl,79
	;mov bh,0Fh
	;int 10h
inicio:	mov ax,00
	mov ah, 02h;
	mov bh,00; página 0
	mov dx,00
	mov posx, 35;		posiciona cursor
	mov posy, 5
	mov dl, posx;		
	mov dh, posy		
	int 10h;	
	mov ah, 02ch; 		Tiempo
	int 21h
	lea si, cadtiempo
	inc si
	mov ax, 00
	mov bx, cx	
	mov al, bh;		22
	mov cx, 02

et1:	div byte ptr [temp]
	add al, 30h
	add ah, 30h
	mov [si], al
	inc si
	mov [si], ah
	inc si
	inc si
	mov ax, 00
	mov al, bl
	
	loop et1
	mov ax, 00
	mov al, dh
	mov cx, 02
et2:	div byte ptr [temp];	
	add al, 30h
	add ah, 30h
	mov [si], al
	inc si;			50
	mov [si], ah
	inc si
	inc si
	mov ax, 00
	mov al, dl
	loop et2

	mov ax, 00
	mov dx, 00
	mov dx, offset cadtiempo; 	muestra en posicion la cadena
	inc dx
	mov ah, 09h
	int 21h
	
	in al, 60h
	dec al
	cmp al, 00
	jne inicio
	
Exit:
	mov ah,04Ch
	int 21h
end
