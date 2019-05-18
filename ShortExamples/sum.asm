Page 60,132
Title Sum Procedure 
.model small 
.stack 64 
.data 
.code
Startprogram:
	mov ecx,'04'
	sub ecx,'0'
	mov edx,'5'
	sub edx,'0'
	
	call sum 
	mov [res],eax
	mov ecx,msg
	