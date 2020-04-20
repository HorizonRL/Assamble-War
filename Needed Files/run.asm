IDEAL
MODEL small
STACK 100h

DATASEG
include "DataSeg.asm"
CODESEG
include "const.asm"
include "Menu.asm"
include "Game.asm"


start:
	mov ax, @data
	mov ds, ax
	
loading:
	GRAPHICS_MODE_TOGGLE
	call InitMouse
	call ShowMouse
	jmp splitThem

resetGameHandler:
	call GameOverHandler
	jmp splitThem
	
splitThem:
	call SplitCards; make the actual loading
	;this proc as a lot of computer clock usage so it takes time
	; so this proc also handles the loading screens trans
	jmp mainHandler
	
mainHandler:
	call Menu
	call Game
	
	cmp [gameOver], true
	je resetGameHandler
	jmp mainHandler

END start
