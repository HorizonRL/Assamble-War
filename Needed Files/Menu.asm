include "Mouse.asm"
include "Print.asm"
include "Screens.asm"

proc Menu
	push bp 
	mov bp ,sp
	
	NewSlotStack;to use is

checkMainSection:
	MAIN_OPEN_SCREEN
	
checkWithoutPrint:
	call GetMouseData

	;check if in play
	pushCords playXL playXR playYB playYT
	call IsInBoundaries
	pop is 
	cmp is, true
	je openScreenPlayPrint

	;check if in info
	pushCords infoXL infoXR infoYB infoYT
	call IsInBoundaries
	pop is 
	cmp is, true
	jne checkExit
	jmp openScreenInfoPrint

checkExit:
	;check if in exit
	pushCords exitXL exitXR exitYB exitYT
	call IsInBoundaries
	pop is 
	cmp is, true
	je openScreenExitPrint
	jmp checkWithoutPrint
	
openScreenPlayPrint: ;print the screen and the pass to after check              
	MAIN_OPEN_SCREEN_PLAY                           
	jmp openScreenPlay            
                                  
openScreenExitPrint: ;print the screen and the pass to after check 
	NewSlotStack; push 0 for a place in stock to ret a bool
	call IsMouseClick 
	pop is 
	cmp is, true
	je delay
	jmp contPrint 
	
delay: ;to prevent instant trans to abs exit from the game 
	   ;when the player return to home screen from info screen
	DELAY_MED 
	jmp contPrint
	
contPrint:
	MAIN_OPEN_SCREEN_EXIT                           
	jmp openScreenExit            
                                  
openScreenInfoPrint: ;print the screen and the pass to after check 
	MAIN_OPEN_SCREEN_INFO
	jmp openScreenInfo

openScreenExit:
	call GetMouseData
	pushCords exitXL exitXR exitYB exitYT
	call IsInBoundaries
	pop is
	cmp is, true
	jne checkMainSectionMiddleJump
	NewSlotStack; push 0 for a place in stock to ret a bool
	call IsMouseClick
	pop is 
	cmp is, true
	jne openScreenExit
	EXIT
	
checkMainSectionMiddleJump:
	jmp checkMainSection

openScreenPlay:
	call GetMouseData
	pushCords playXL playXR playYB playYT
	call IsInBoundaries
	pop is 
	cmp is, true
	jne checkMainSectionMiddleJump
	NewSlotStack; push 0 for a place in stock to ret a bool
	call IsMouseClick
	pop is 
	cmp is, true
	jne openScreenPlay
	jmp startGame
	
openScreenInfo:
	call GetMouseData
	pushCords infoXL infoXR infoYB infoYT
	call IsInBoundaries
	pop is 
	cmp is, true
	je continueOpenScreenInfo
	jmp checkMainSectionMiddleJump
continueOpenScreenInfo:
	NewSlotStack; push 0 for a place in stock to ret a bool
	call IsMouseClick
	pop is 
	cmp is, true
	jne openScreenInfo
	jmp infoScreenPrint
	
infoScreen:
	call GetMouseData
	pushCords infoEscXL infoEscXR infoEscYB infoEscYT
	call IsInBoundaries
	pop is 
	cmp is, true
	je infoScreenEscPrint
	jmp infoScreen
	
infoScreenPrint:
	INFO_SCREEN
	jmp infoScreen
	
infoScreenEscPrint:
	INFO_SCREEN_ESC
	jmp infoScreenEsc
	
infoScreenPrintMiddleJump:
	jmp infoScreenPrint

infoScreenEsc:
	call GetMouseData
	pushCords infoEscXL infoEscXR infoEscYB infoEscYT
	call IsInBoundaries
	pop is 
	cmp is, true
	jne infoScreenPrintMiddleJump
	NewSlotStack; push 0 for a place in stock to ret a bool
	call IsMouseClick
	pop is 
	cmp is, true
	jne infoScreenEsc
	jmp checkMainSectionMiddleJump
	
infoScreenMiddleJump:
	jmp infoScreen
	
startGame:
	pop ax
	pop bp
	ret

endp Menu
