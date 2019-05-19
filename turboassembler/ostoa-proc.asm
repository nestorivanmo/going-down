Page 60,132
Title ComputerClockInRealTime-Procedures
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
MIDSCREEN EQU 20h
;computer clock variables 
computerTime db 11, '  :  :  :  ', '$'
temp db 10 
;ascii variables 
WHITESPACE EQU 32 
asciiIndex dw 00 
ASCIIWIDTH EQU 32
ASCIIHEIGHT EQU 9
initialRow dw 06
initialColumn dw 03 
;gral variables 
warning db 30, 'Extended ASCII with Procedures','$'

.code 
Beginning: 
	call slvData
	call clrScreen
	call drawmargins
	
	mov ax,06h
	push ax 
	mov ax,15h
	push ax 
	call moveCursor
	
	mov ax,offset warning
	push ax 
	call printS
	
	mov ax,07h;initial row 
	push ax 
	mov ax,04h;initial column 
	push ax 
	mov ax,ASCIIWIDTH
	push ax 
	mov ax,ASCIIHEIGHT
	push ax
	call ascii 
	
	mov ax,02h 
	push ax
	mov ax,MIDSCREEN
	push ax 
	call computerclock
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
printS proc; Push order(string)
	mov bp,sp
	mov dx,[bp+2]
	inc dx
	mov ah,09h
	int 21h
	ret 2
printS endp
printC proc; Push order(char) 
	mov bp,sp 
	mov dl,[bp+2]
	mov ah,02h 
	int 21h 
	ret 2
printC endp
	
ascii proc; Push Order: (initialX,initialY,numRows,numCols)
	mov bp,sp 
	;print Extended ASCII
	mov bp,sp 
	mov cx,[bp+2]
	mov bx,cx 
	rowsLoop:
		mov ax,[bp+8]
		push ax 
		inc ax 
		inc ax 
		mov [bp+8],ax 
		mov ax,[bp+6]
		push ax 
		call moveCursor
		mov bp,sp
		mov cx,[bp+4]
		colsLoop:
			mov ax,asciiIndex
			push ax 
			call printC
			mov ax,WHITESPACE
			push ax 
			call printC
			mov bp,sp 
			inc asciiIndex
		loop colsLoop
		dec bx 
		mov cx,bx 
	loop rowsLoop
	ret 8
ascii endp

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

computerclock proc; Push order(row,column)
getComputerClock:
	mov bp,sp 
	;move cursor to initial position 
	mov ax,[bp+4]
	push ax 
	mov ax,[bp+2]
	push ax 
	call moveCursor
	;get computer clock time 
	mov ah,02ch
	int 21h
	lea si,computerTime
	inc si
	;add hours and minutes to string 
	mov ax,02 
	push ax 
	mov ax,cx 
	push ax 
	call time
	;add seconds and micro seconds to string 
	mov ax,02 
	push ax 
	mov ax,dx 
	push ax 
	call time 
	;print computerTime string to the screen 
	mov ax,offset computerTime
	push ax 
	call printS
	;stop when user clicks ESC key 
	in al,60h
	dec al
	cmp al,00
	jne getComputerClock
	ret 4
computerclock endp

;clock procedures 
time proc; Push order(numTimes,content,string)
	mov bp,sp
	;clean registers 
	xor ax,ax 
	xor bx,bx 
	xor cx,cx 
	;fetch parameters
	mov bx,[bp+2];content
	mov al,bh
	mov cx,[bp+4];numTimes
	timeloop:
		div byte ptr [temp]
		add al,30h
		add ah,30h
		mov [si],al;add first hours digit  
		inc si
		mov [si],ah;add second hours digit 
		inc si
		inc si
		mov ax,00 
		mov al,bl;change hours for minutes 
	loop timeloop
	ret 4
time endp

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