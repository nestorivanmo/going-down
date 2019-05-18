Page 60,132
Title MarginWithProcedures
.model small 
.stack 64 
.data 
;drawing characters 
TLC DW 201 
TRC DW 203 
BLC DW 200 
BRC DW 188 
ML DW 204 
MR DW 185 
V EQU 186 
H EQU 205 
;screen constants 
PAGEN EQU 00 
WIDTHSCREEN EQU 49h
HEIGHTSCREEN EQU 18h
MIDSCREEN EQU 18H
;computer clock variables 
computerTime db 11, '  :  :  :  ', '$'
temp db 10 

.code 
Beginning: 
	call slvData
	call clrScreen
Margins:
	call drawmargins
ComputerClockRealTime:
	call computerclock
ASCII_Extended:
	;call ascii
Ending: 
	call exitP

;basic procedures 
slvData proc 
	mov ax,@data 
	mov ds,ax 
	mov es,ax 
	ret 
slvData endp 
clrScreen proc 
	mov ah,0fh 
	int 10h 
	mov ah,0 
	int 10h 
	ret 
clrScreen endp  
exitP proc 
	mov ah,04ch 
	int 21h
	ret 
exitP endp
moveCursor proc ; Push order(row,column)
	mov bp,sp 
	mov dl,[bp+2];column 
	mov dh,[bp+4];row 
	mov bh,PAGEN
	mov ah,02h 
	int 10h
	ret 4
moveCursor endp
drawmargins proc 
	;top margin 
	mov ax,00
	push ax
	mov ax,00
	push ax 
	push TLC
	push TRC
	call drawHorizontalMargin
	;bottom margin 
	mov ax,HEIGHTSCREEN
	push ax
	mov ax,00
	push ax 
	push BLC
	push BRC
	call drawHorizontalMargin
	;left margin 
	mov ax,01
	push ax 
	mov ax,00
	push ax 
	call drawVerticalMargin
	;right margin 
	mov ax,01
	push ax 
	mov ax,WIDTHSCREEN
	inc ax 
	push ax 
	call drawVerticalMargin
	;middle margin 
	mov ax,4h
	push ax
	mov ax,00
	push ax 
	push ML
	push MR
	call drawHorizontalMargin
	ret 
drawmargins endp
computerclock proc 
	mov bp,sp
	;move cursor to initial position 
	mov ax,02h
	push ax 
	mov ax,MIDSCREEN
	push ax 
	call moveCursor
	;get computer clock in real time 
	
	ret 
computerclock endp

;drawing procedures 
drawHorizontalMargin proc ;pushOrder(row,column,leftC,rightC)
	mov bp,sp
	;move cursor to inital pos 
	mov ax,[bp+8]
	push ax 
	mov ax,[bp+6]
	push ax 
	call moveCursor
	;draw left corner 
	mov bp,sp
	mov bx,PAGEN
	mov cx,1
	mov al,[bp+4]
	mov ah,0ah
	int 10h
	;move cursor
	mov ax,[bp+8]
	push ax 
	mov ax,WIDTHSCREEN
	inc ax 
	push ax 
	call moveCursor
	;draw right corner 
	mov bp,sp 
	mov cx,1
	mov al,[bp+2]
	mov ah,0ah
	int 10h
	;move cursor 
	mov ax,[bp+8]
	push ax 
	mov ax,[bp+6]
	inc ax 
	push ax 
	call moveCursor
	;draw horizontal lines 
	push WIDTHSCREEN
	push H
	call horizontalMargin
	ret 8
drawHorizontalMargin endp 
horizontalMargin proc ; Push order(widthscreen,character)
	mov bp,sp
	mov cx,[bp+4];width screen 
	mov al,[bp+2];character 
	mov ah,0ah
	int 10h 
	ret 4
horizontalMargin endp 
drawVerticalMargin proc ;Push order(row,column)
	mov bp,sp 
	;move cursor to initial position 
	mov ax,[bp+4]
	push ax 
	mov ax,[bp+2]
	push ax 
	call moveCursor
	;draw vertical margin 
	mov bp,sp 
	mov ax,HEIGHTSCREEN
	dec ax 
	mov cx,ax 
	mov bx,[bp+4]
	verticalmargin: 
		mov dl,V
		mov ah,02h
		int 21h
		inc bx   
		push bx 
		mov ax,[bp+2]
		push ax 
		call moveCursor
		mov bp,sp 
	loop verticalmargin
	ret 4 
drawVerticalMargin endp
;
end






















