macro PRINT_BMP
	
	call OpenFile    
	call ReadHeader
	call ReadPalette
	call CopyPal
	call HideMouse
	call CopyBitmap
	call ShowMouse
	call CloseFile
endm 
;---------------------------------------------------------------;
macro PRINT_BMPByPosition
	
	call OpenFile    
	call ReadHeader
	call ReadPalette
	call CopyPal
	call HideMouse
	call CopyBitmapForPrintByPosition
	call ShowMouse
	call CloseFile
endm 
;---------------------------------------------------------------;
proc OpenFile

	mov ah, 3Dh    
	xor al, al
	mov dx, offset filename
	int 21h
	mov [filehandle], ax
	ret

endp OpenFile
;---------------------------------------------------------------;
proc ReadHeader
; Read BMP file header, 54 bytes
	mov ah,3fh
	mov bx, [filehandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	ret
endp ReadHeader
;---------------------------------------------------------------;
proc ReadPalette
	; Read BMP file color palette, 256 colors * 4 bytes (400h)
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	ret
endp ReadPalette 
;---------------------------------------------------------------;
proc CopyPal
	; Copy the colors palette to the video memory
	; The number of the first color should be sent to port 3C8h
	; The palette is sent to port 3C9h
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0
	; Copy starting color to port 3C8h
	out dx,al
	; Copy palette itself to port 3C9h 
	inc dx
	
PalLoop:
; Note: Colors in a BMP file are saved as BGR values rather than RGB.
	mov al,[si+2] ; Get red value.
	shr al,2 ; Max. is 255, but video palette maximal
	 ; value is 63. Therefore dividing by 4.
	out dx,al ; Send it.
	mov al,[si+1] ; Get green value.
	shr al,2
	out dx,al ; Send it.
	mov al,[si] ; Get blue value
	shr al,2
	out dx,al ; Send it.
	add si,4 ; Point to next color.
	 ; (There is a null chr. after every color.)
	loop PalLoop
	ret
endp CopyPal
;---------------------------------------------------------------;
proc CopyBitmap
	; BMP graphics are saved upside-down.
	; Read the graphic line by line (200 lines in VGA format),
	; displaying the lines from bottom to top.
	mov ax, 0A000h
	mov es, ax
	mov cx, 200
	
PrintBMPLoop:
	push cx 
	; di = cx*320, point to the correct screen line
	mov di,cx
	shl cx,6
	shl di,8
	add di,cx
	; Read one line
	mov ah,3fh
	mov cx,320
	mov dx,offset ScrLine
	int 21h
	cld ; Clear direction flag, for movsb
	mov cx,320
	mov si,offset ScrLine 
	; Copy one line into video memory
	rep movsb ; Copy line to the screen
 ;rep movsb is same as the following code:
 ;mov es:di, ds:si
 ;inc si
 ;inc di
 ;dec cx
 ;loop until cx=0
	pop cx
	loop PrintBMPLoop
	ret
endp CopyBitmap  
;---------------------------------------------------------------;
AmountDealy equ [bp + 4]
proc DoDealy
	push bp 
	mov bp,sp
	push ax
	push cx
	
	Clock equ es:6Ch
	mov ax, 40h
	mov es, ax
	mov ax, [Clock]       ;gets a value for delay
	FirstTick:
	cmp ax, [Clock]
	je FirstTick
	; count 10 sec
	mov cx, AmountDealy ; AmountDealy x 0.055sec = time to delay
	DelayLoop:
	mov ax, [Clock]
	Tick:
	cmp ax, [Clock]
	je Tick 
	loop DelayLoop
	
	pop cx
	pop ax
	pop bp
	ret 2
endp DoDealy
;---------------------------------------------------------------;
proc CloseFile
	mov ah, 3Eh
	mov bx, [filehandle]
	int 21h
	ret
endp CloseFile
;---------------------------------------------------------------;
x equ [word ptr bp + 4]
y equ [word ptr bp + 6]
w equ [word ptr bp + 8]
h equ [word ptr bp + 10]
proc CopyBitmapForPrintByPosition	
	push bp
	mov bp, sp 
	;same code as CopyBitmap except the x,y positions 
	;specifies res for (h * w) for the cards
	mov ax, 0A000h
	mov es, ax
	mov cx, h
PositionPrintBMPLoop:
	push cx
	add cx, y ;y
	mov di,cx
	shl cx,6
	shl di,8
	add di,cx
	add di, x ; x
	mov ah,3fh
	mov cx, w
	mov dx,offset ScrLine
	int 21h
	cld 
	mov cx, w
	mov si,offset ScrLine
	rep movsb 
	pop cx
	loop PositionPrintBMPLoop
	
	pop bp
	ret 8
endp CopyBitmapForPrintByPosition
;---------------------------------------------------------------;
leftX equ [word ptr bp + 4]
rightX equ [word ptr bp + 6]    
topY equ [word ptr bp + 8]    
bottomY equ [word ptr bp + 10] 
isIn equ  [word ptr bp + 10] 
proc IsInBoundaries

	push bp
	mov bp, sp 

check:
	;check if it's on x zone
	cmp cx, leftX
	jb notInBoundaries

	cmp cx, rightX
	ja notInBoundaries
	
	;check if it's on y zone
	cmp dx, topY
	jb notInBoundaries
	cmp dx, bottomY
	ja notInBoundaries
	jmp InBoundaries
notInBoundaries:
	mov isIn, false
	jmp finalCheckInBoundaries
	
InBoundaries:
	mov isIn, true
	jmp finalCheckInBoundaries
	
finalCheckInBoundaries:
	pop bp
	ret 6 
	
endp IsInBoundaries
