Title Ciclos Anidados 
.model small 
.stack 32 
.data 
XLENGTH EQU 33
YLENGTH EQU 8
WHITESPACE EQU 32

asciiIndex db 32
row db 0
column db 4
.code 
Inicio: 
	mov ax,@data 
	mov ds,ax 
	;clear screen
	mov ah,0fh
	int 10h
	mov ah,0
	int 10h
	;nested loops 
	mov cx,YLENGTH
	mov bx,YLENGTH
	l1: 
		mov dh,row;row
		mov dl,column;column
		mov ah,02h
		int 10h
		inc row 
		mov cx,XLENGTH
		l2:
			mov dl, asciiIndex
			mov ah,02h
			int 21h
			mov dl, WHITESPACE
			mov ah,02h
			int 21h
			inc asciiIndex
		loop l2
		dec bx 
		mov cx,bx	
	loop l1 
Fin:
	mov ah,04ch
	int 21h
end 