Page 60, 132
Title interrupciones
.model small
.stack 64
.data
ubica db 'AQUI TOY'
cadRecibida db 10,0,'         '
cadImprimir db 'Hola mundo','$'
.code
Principal   proc far
	mov ax, @data
	mov ds, ax
	mov es, ax	
	; implementando interrupciones
	;int 21h opción 08h
	mov ah,08
	int 21h
	; int 21h opción 0ah
	mov dx,offset cadRecibida;
	mov ah,0ah
	int 21h
	; int 21h opción 02h
	mov dl,39h
	mov ah,02h
	int 21h
	; int 21h opción 09h
	mov ah,09
	mov dx,offset cadImprimir
	int 21h
	; int 10h opción 02h
	mov ah,02h
	mov dl,40
	mov dh,12
	mov bh,00
	int 10h
	; int 21h opción 2ch
	mov ah,02ch
	int 21h
	
	mov ah,04ch
	mov al,0
	int 21h
Principal  endp	
end Principal
