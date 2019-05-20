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
.code 
Beginning: 
	slvData
	clrScreen
	;whole margin 
	drawSquaredMargin 0,0,WIDTHSCREEN,HEIGHTSCREEN
	;mid margin 
	drawHorizontalMargin ML,MR,H,0,4,WIDTHSCREEN
Ending: 
	finishExec
end 	