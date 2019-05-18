Page 60,132
Title Procedimientos
.model small 
.stack 64 
.data 
x dw 00 
y dw 00 
z dw 02
firstTerm dw 00
secondTerm dw 00
thirdTerm dw 00 
tmp dw 00 
result db '  ','$'
.code 
SolveDataSegment:
	mov ax,@data 
	mov ds,ax 
	mov es,ax 
CalculateX: ; x = Z*Z*Z
	mov dx,03;x raised to the 3 
	push z 
	push dx 
	call POW;call to power procedure 
	mov [x+1],ax
	
CalculateY: ; Y = 2*(X*X) + 2X +5!
	CalculateFirstTerm:
		mov dx,02
		push x 
		push dx 
		call MULT
		mov [firstTerm],ax
	
	mov bx,00
	mov bx,[firstTerm];bx=x
	add bh,30h
	add bl,30h
	
PrintProgramOutput:
	lea si,result
	mov [si],bh
	mov [si+1],bl
	mov dx,offset result
	mov ah,09	
	int 21h
EndProgram: 
	mov ah,04Ch
	int 21h
	
;procedures 
POW proc 
	mov bp,sp;move base pointer to stack pointer 
	mov ax,01;this needs to be done for the multiplication
	mov bx,[bp+4];bx=z
	mov cx,[bp+2];cx=dx=3
	potLoop: mul bx 
	loop potLoop
	ret 4
POW endp 

MULT proc 
	mov bp,sp
	mov ax,01
	mov bx,00
	mov bx,[bp+4];bx=x
	mov ax,[bp+2];cx=2
	mul bx
	ret 4
MULT endp
end 
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	