;in bx, first bit is 1,left click is pressed. second bit is 1 ,right click is pressed
;in cx: x
;in dx: y
proc InitMouse
	push ax
	
	xor ax,ax
	int 33h
	
	pop ax
	ret
endp InitMouse
;---------------------------------------------------------------;
proc GetMouseData	
	push ax
	
	mov ax, 3h
	int 33h ; get data
	shr cx, 1 ;to adjust to amount of pixeles in screen
	
	pop ax
	ret
endp GetMouseData
;---------------------------------------------------------------;
ciliked equ [word ptr bp + 4]
proc IsMouseClick
	push bp
	mov bp, sp
	cmp bx, mouseLClick
	je pressed
	jmp notPressed
	
pressed:
	mov ciliked, true
	jmp finishIsMouseClick

notPressed:
	mov ciliked, false
	jmp finishIsMouseClick
	
finishIsMouseClick:
	pop bp
	ret 
endp IsMouseClick
;---------------------------------------------------------------;
proc HideMouse
	push ax
	
	mov  ax,0002h                ; hide mouse cursor
	int  33h
	
	pop ax
	ret
endp HideMouse
;---------------------------------------------------------------;
proc ShowMouse
	push ax
	
	mov ax, 0001h ; show hide mouse cursor
	int 33h
	
	pop ax
	ret
endp ShowMouse
