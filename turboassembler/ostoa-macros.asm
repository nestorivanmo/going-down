Page 60,132 
Title ExtendedASCII_macros 
;macros 
slvData macro 
	mov ax,@data 
	mov ds,ax 
	mov es,ax 
endm 
clrScreen macro 
	mov ah,0fh
	int 10h
	mov ah,0
	int 10h
endm
finishExec macro 
	mov ah,04ch 
	int 21h
endm 
;basic macros 
moveCursor macro x,y
	mov dl,offset x
	mov dh,offset y
	mov bh,PAGEN
	mov ah,02h
	int 10h
endm 
printChar macro char 
	mov dl,offset char 
	mov ah,02h
	int 21h
endm 
printString macro string,x,y
	moveCursor x,y
	mov ax,offset string 
	push ax 
	call printS
endm 
printMulChar macro char,numTimes 
	mov bh,PAGEN
	mov cx,numTimes
	mov al,char 
	mov ah,0ah
	int 10h
endm 
;margin macros 
drawSquaredMargin macro x,y,widthS,heightS 
	moveCursor x,y
	drawHorizontalMargin TLC,TRC,H,x,y,widthS
	drawHorizontalMargin BLC,BRC,H,x,heightS,widthS
	mov al,y
	inc al
	drawVerticalMargin V,x,al,heightS
	mov bl,y
	inc bl 
	drawVerticalMargin V,widthS,bl,heightS
endm
drawHorizontalMargin macro leftChar,rightChar,midChar,x,y,widthS
	moveCursor x,y
	printChar leftChar
	mov ah,x 
	inc ah 
	moveCursor ah,y 
	mov ax,widthS
	dec ax
	printMulChar midChar,ax
	moveCursor widthS,y
	printChar rightChar
endm
drawVerticalMargin macro midChar,x,y,heightS
	local verticalLoop
	moveCursor x,y
	xor dx,dx
	mov dx,heightS
	dec dx 
	mov cx,dx
	mov bl,y
	verticalLoop:
		printChar midChar
		inc bl
		moveCursor x,bl
	loop verticalLoop
endm 
;ascii macros 
printASCII macro x,y,numCols,numRows 
	mov ax,x 
	push ax 
	mov ax,y 
	push ax 
	mov ax,numCols
	push ax 
	mov ax,numRows
	push ax 
	call ascii
endm 
printComputerClock macro x,y
	mov ax,y
	push ax 
	mov ax,x 
	push ax 
	call computerClock
endm
.model small 
.stack 64 
.data 
;drawing characters 
TLC EQU 201 
TRC EQU 203 
BLC EQU 200 
BRC EQU 188 
ML EQU 204 
MR EQU 185 
V EQU 186 
H EQU 205
;screen constants 
PAGEN EQU 00 
WIDTHSCREEN EQU 49h
HEIGHTSCREEN EQU 18h
MIDSCREEN EQU 20h
;ascii variables 
WHITESPACE EQU 32 
asciiIndex dw 00
ASCIIWIDTH EQU 32 
ASCIIHEIGHT EQU 9 
;clock vars 
computerTime db 11, '  :  :  :  ', '$'
temp db 10 ;gral 
warning db 26, 'Extended ASCII with Macros','$'
.code 
Beginning: 
	slvData
	clrScreen
	drawSquaredMargin 0,0,WIDTHSCREEN,HEIGHTSCREEN
	drawHorizontalMargin ML,MR,H,0,3,WIDTHSCREEN
	printString warning,22,5
	printASCII 7,4,ASCIIWIDTH,ASCIIHEIGHT
	printComputerClock MIDSCREEN,2
Ending: 
	finishExec
;some procedures 
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
		call moveCursorP
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
printC proc; Push order(char) 
	mov bp,sp
	mov dl,[bp+2]
	mov ah,02h 
	int 21h 
	ret 2
printC endp
moveCursorP proc ; Push order(row,column)
	mov bp,sp 
	mov dl,[bp+2];column 
	mov dh,[bp+4];row 
	mov bh,PAGEN
	mov ah,02h 
	int 10h
	ret 4
moveCursorP endp
printS proc; Push order(string)
	mov bp,sp
	mov dx,[bp+2]
	inc dx
	mov ah,09h
	int 21h
	ret 2
printS endp

computerclock proc; Push order(row,column)
getComputerClock:
	mov bp,sp 
	;move cursor to initial position 
	mov ax,[bp+4]
	push ax 
	mov ax,[bp+2]
	push ax 
	call moveCursorP
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
end