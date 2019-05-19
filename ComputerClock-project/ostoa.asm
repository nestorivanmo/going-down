Page 60,132
Title COMPUTER REAL TIME 
.model small 
.stack 32 
.data 
TOPLEFTCORNER EQU 201
TOPRIGHTCORNER EQU 203
BOTTOMRIGHTCORNER EQU 188
BOTTOMLEFTCORNER EQU 200
MIDDLELEFT EQU 204
MIDDLERIGHT EQU 185
VERTICAL EQU 186
HORIZONTAL EQU 205

XTIMES EQU 49h
YTIMES EQU 18h
BOTTOMMARGINXTIMES EQU 48H
COLOR EQU 0FH
PAGENUMBER EQU 00 
EXTENDEDASCIIXTIMES EQU 23H
SPACE EQU 32
XLENGTH EQU 33
YLENGTH EQU 8
WHITESPACE EQU 32

computerTime db 11, '  :  :  :  ', '$'
temp db 10 
verticalM db 1
leftVerticalM db 1
bottomM db 1
posx db ?
posy db ?
asciiIndex db 32
row db 5
column db 4
verticalIndex db 03h
bottomMargin db XTIMES

.code 
StartProgram:
	mov ax,@data 
	mov ds,ax 
	;clear screen 
	mov ah,0fh
	int 10h
	mov ah,0
	int 10h
DrawMargin:
	;top left corner  
	mov ah,09h
	mov bh,00
	mov cx,1h
	mov al,TOPLEFTCORNER
	mov bl,COLOR
	int 10h
	;move cursor 
	mov ah,02h
	mov dh,0;row
	mov dl,1;column
	mov bh,PAGENUMBER
	int 10h
	;top margin 
	mov ah,09h; option to write a character with attribute 
	mov bh,PAGENUMBER; page number 
	mov cx,XTIMES; number of chars to write 
	mov al,HORIZONTAL; character to write 
	mov bl,COLOR;set fg and bg color 
	int 10h
	;mov cursor to end of top margin 
	mov ah,02h
	mov dh,0;row
	mov dl,XTIMES;column
	mov bh,PAGENUMBER
	int 10h
	;top right corner 
	mov ah,09h
	mov bh,PAGENUMBER
	mov cx,1h
	mov al,TOPRIGHTCORNER
	mov bl,COLOR 
	int 10h
	;move cursor 
	mov ah,02h
	mov dh,1
	mov dl,XTIMES
	mov bh,PAGENUMBER
	int 10h
	;right vertical margin
	mov cx,YTIMES
	rightMargin: mov ah,02h
	mov dl,VERTICAL
	int 21h
	mov ah,02h
	mov dh,verticalM;row 
	mov dl,XTIMES;column
	mov bh,PAGENUMBER
	int 10h
	inc verticalM
	loop rightMargin
	;move cursor 
	mov ah,02h
	mov dh,YTIMES;row 
	mov dl,XTIMES; column 
	int 10h
	;bottom RIGHT corner 
	mov ah,09h; option to write a character with attribute 
	mov bh,PAGENUMBER; page number 
	mov cx,01h; number of chars to write 
	mov al,BOTTOMRIGHTCORNER; character to write 
	int 10h
	;move cursor 
	mov ah,02h
	mov dh,YTIMES;row 
	mov dl,00h; column 
	int 10h
	;bottom left corner 
	mov ah,02h
	mov dl,BOTTOMLEFTCORNER
	int 21h 
	;move cursor 
	mov ah,02h
	mov dh,YTIMES;row 
	mov dl,01h; column 
	int 10h
	;bottom margin 
	mov ah,09h; option to write a character with attribute 
	mov bh,PAGENUMBER; page number
	mov cx,BOTTOMMARGINXTIMES; number of chars to write 
	mov al,HORIZONTAL; character to write 
	mov bl,COLOR;set fg and bg color 
	int 10h
	;move cursor to top left corner 
	mov ah,02h
	mov dh,01h;row
	mov dl,00h;column
	int 10h
	;left vertical margin 
	mov cx,YTIMES
	leftMargin: mov ah,02h
	mov dl,VERTICAL
	int 21h
	mov ah,02h
	mov dh,leftVerticalM;row 
	mov dl,00h;column
	mov bh,PAGENUMBER
	int 10h
	inc leftVerticalM
	
	loop leftMargin
	
	;move cursor 
	mov ah,02h
	mov dh,02h;row 
	mov dl,00h;column
	mov bh,00h
	int 10h
	mov ah,02h
	mov dl,MIDDLELEFT
	int 21h
	;move cursor 
	mov ah,02h
	mov dh,02h;row 
	mov dl,01h;column
	mov bh,00h
	int 10h
	;middle margin 
	mov ah,09h; option to write a character with attribute 
	mov bh,PAGENUMBER; page number 
	mov cx,BOTTOMMARGINXTIMES; number of chars to write 
	mov al,HORIZONTAL; character to write 
	mov bl,COLOR;set fg and bg color 
	int 10h
	;move cursor 
	mov ah,02h
	mov dh,02h;row 
	mov dl,XTIMES;column
	mov bh,00h
	int 10h
	mov ah,02h
	mov dl,MIDDLERIGHT
	int 21h
	
ExtendedASCII:
	;move cursor 
	mov ah,02h
	mov dh,verticalIndex
	mov dl,02h 
	int 10h
	;extended ascii
	mov cx,YLENGTH
	mov bx,YLENGTH
	l1: 
		mov dh,row;row
		mov dl,column;column
		mov ah,02h
		int 10h
		inc row 
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
	
getComputerClock:	
	;move cursor 
	mov ax,00
	mov bh,00
	mov dx,00
	mov posx,20h
	mov posy,01h
	mov dl, posx;		
	mov dh, posy	
	mov ah,02h	
	int 10h;	
	;get computer clock time 
	mov ah,02ch
	int 21h
	;load efective address 
	lea si,computerTime
	inc si
	mov ax,00
	mov bx,00
	mov bx,cx; bx=hours&minutes 
	mov al,bh; al=hours
	mov cx,02
	hoursMinutesLoop:	
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
	loop hoursMinutesLoop
	mov ax,00
	mov al,dh; al now has seconds and microseconds 
	mov cx,02
	secondsMicrosecondsLoop:	
		div byte ptr [temp];	
		add al,30h
		add ah,30h
		mov [si],al; add first seconds digit 
		inc si;			
		mov [si],ah; add second seconds digit 
		inc si
		inc si
		mov ax,00
		mov al,dl; now change seconds for microseconds 
	loop secondsMicrosecondsLoop
	mov ax,00
	mov dx,00
	mov dx,offset computerTime
	inc dx
	;print computerTime string to the screen 
	mov ah,09h
	int 21h
	;stop when user clicks ESC key 
	in al,60h
	dec al
	cmp al,00
	jne getComputerClock
EndProgram: 
	mov ah,04Ch
	int 21h
end 