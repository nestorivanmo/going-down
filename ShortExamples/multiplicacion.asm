Page 60,132
Title Multiplicacion 
.model small 
.stack 64 
.code 
StartProgram:
	mov ax,01
	mov cx,03
	pot: 
		mov bx,02
		mul bx 
	loop pot 
EndProgram:
	mov ah,04Ch
	int 21h
end 