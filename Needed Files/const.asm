
;general{
	true equ 1
	false equ 0

	is equ [word ptr bp - 2]

;}

;game{
	equalCardsState equ 254h

	warStateMy equ 148h
	warStateOpponent equ 118h
	NotWar equ 8
	thereAreNoZero equ 3339h
;}

;res{
	cardResH equ 50
	cardResW equ 76

	escResH equ 30
	escResW equ 48

	blankBackgroundResH equ 120
	blankBackgroundResW equ 320

	crownResH equ 24
	crownResW equ 36

	finalCrownResH equ 72
	finalCrownResW equ 108

	warResH equ 50
	warResW equ 76
	
;}

;location of print{
	;note: opponent is right player my is left player 
	xPositionMyCurrntCards equ 76
	yPositionMYCurrntCards equ 65

	xPositionOpponentCurrntCards equ 168
	yPositionOpponentCurrntCards equ 65

	xPositionEsc equ 0
	yPositionEsc equ 0

	yPositionMyCrown equ 125
	xPositionMyCrown equ 12

	yPositionOpponentCrown equ 125
	xPositionOpponentCrown equ 248

	yPositionWarSateLabel equ 149
	xPositionWarSateLabel equ 120

	yPositionMyFirstWarState equ 65
	xPositionMyFirstWarState equ 64

	yPositionMySecWarState equ 65
	xPositionMySecWarState equ 49

	yPositionMyThirdWarState equ 65
	xPositionMyThirdWarState equ 34

	yPositionMyFourthWarState equ 65
	xPositionMyFourthWarState equ 19

	yPositionOpponentFirstWarState equ 65
	xPositionOpponentFirstWarState equ 183
			 
	yPositionOpponentSecWarState equ 65
	xPositionOpponentSecWarState equ 198
			 
	yPositionOpponentThirdWarState equ 65
	xPositionOpponentThirdWarState equ 213
			 
	yPositionOpponentFourthWarState equ 65
	xPositionOpponentFourthWarState equ 228

	yPositionBlankScreen equ 30
	xPositionBlankScreen equ 0
;}

;GUI map{
	playXL equ 141
	playXR equ 178
	playYT equ 100
	playYB equ 119

	infoXL equ 142
	infoXR equ 176
	infoYT equ 144
	infoYB equ 163

	exitXL equ 3
	exitXR equ 38
	exitYT equ 7
	exitYB equ 26

	InfoEscXL equ 3
	InfoEscXR equ 38
	InfoEscYT equ 7
	InfoEscYB equ  26

	inGameEscXL equ 15
	inGameEscXR equ 30
	inGameEscYT equ 10
	inGameEscYB equ 20

	myCardStackXL equ 2
	myCardStackXR equ 69
	myCardStackYT equ 149
	myCardStackYB equ 196
;}

;macros{
	macro pushCords xL, xR, yB, yT;for isInBounderys
			push yB
			push yT
			push xR
			push xL
	endm
	
	macro NewSlotStack;for using inside proc equs and to ret
		push 0 
	endm NewSlotStack

	macro EXIT;exit program
		mov ax, 3h
		int 10h
		mov ax, 4c00h
		int 21h
	endm EXIT
	
	macro GRAPHICS_MODE_TOGGLE; for turning on/off graphics mode
		mov ax, 13h
		int 10h
	endm

	;print to (x,y) location{
		macro printToOpponentCurrntCards
			push yPositionOpponentCurrntCards
			push xPositionOpponentCurrntCards
		endm

		macro printToMyCurrntCards
			push yPositionMyCurrntCards
			push xPositionMyCurrntCards
		endm

		macro printToMyCurrntCardsFirstWarState
			push cardResH
			push cardResW
			push yPositionMyFirstWarState
			push xPositionMyFirstWarState
		endm

		macro printToMyCurrntCardsSecWarState
			push cardResH
			push cardResW
			push yPositionMySecWarState
			push xPositionMySecWarState
		endm

		macro printToMyCurrntCardsThirdWarState
			push cardResH
			push cardResW
			push yPositionMyThirdWarState
			push xPositionMyThirdWarState
		endm

		macro printToMyCurrntCardsFourthWarState
			push yPositionMyFourthWarState
			push xPositionMyFourthWarState
		endm

		macro printToOpponentCurrntCardsFirstWarState
			push cardResH
			push cardResW
			push yPositionOpponentFirstWarState
			push xPositionOpponentFirstWarState
		endm

		macro printToOpponentCurrntCardsSecWarState
			push cardResH
			push cardResW
			push yPositionOpponentSecWarState
			push xPositionOpponentSecWarState
		endm

		macro printToOpponentCurrntCardsThirdWarState
			push cardResH
			push cardResW
			push yPositionOpponentThirdWarState
			push xPositionOpponentThirdWarState
		endm

		macro printToOpponentCurrntCardsFourthWarState
			push yPositionOpponentFourthWarState
			push xPositionOpponentFourthWarState
		endm

		macro printToESC
			push escResH
			push escResW
			push yPositionEsc
			push xPositionEsc
		endm

		macro printToBlankBG
			push blankBackgroundResH
			push blankBackgroundResW
			push yPositionBlankScreen
			push xPositionBlankScreen
		endm

		macro printToOpponentCrown
			push crownResH
			push crownResW
			push yPositionOpponentCrown
			push xPositionOpponentCrown
		endm

		macro printToMyCrown
			push crownResH
			push crownResW
			push yPositionMyCrown
			push xPositionMyCrown
		endm

		macro printToWarLabel
			push warResH
			push warResW
			push yPositionWarSateLabel 
			push xPositionWarSateLabel 
		endm
		
		macro I_AM_THE_WINNER; full sequence
		printToBlankBG
		printToMyCrown
		FINAL_WINNER_CROWN
		endm

		macro OPPONENT_IS_THE_WINNER; full sequence
			printToBlankBG
			printToOpponentCrown
			FINAL_WINNER_CROWN
		endm
	;}
	
	;delay{
		macro DELAY_lONG
			push 20 ;0.055 * 20 = wanted delay(apx = 1.1sec)
			call DoDealy
		endm
			
		macro DELAY_MED
			push 12 ;0.055 * 12 = wanted delay(apx = 0.66sec)
			call DoDealy
		endm

		macro DELAY_SHORT
			push 8 ;0.055 * 8 = wanted delay(apx = 0.44sec)
			call DoDealy
		endm
		
		macro DELAY_VERY_SHORT
			push 3 ;0.055 * 3 = wanted delay(apx = 0.165sec)
			call DoDealy
		endm
		
		macro RANDOM_DELAY  ;random delay between calling the random function,
			push ax			;because it uses the comp clock and the delay 
			push 4			;makes the random function less predictable
			push 1
			call  Random
			call DoDealy
			pop ax
		endm
	;}
	
	;random presets{
		macro makeARandomCardIndex ;for getting a random num from opponent/my stack
			push 51
			push 0
			call Random
		endm

		macro makeARandomSplit ; for getting a random num from all cards
			push 52
			push 1
			call Random
		endm
	
	;}
	
	;Start & End Handler of procs & macrosz{
		macro StartFunction
			push bp
			mov bp,sp
			push ax
			push bx
			push cx
			push dx
			push si
			push di
		endm
		
		macro EndFunction
			
			pop di
			pop si
			pop dx
			pop cx
			pop bx
			pop ax
			pop bp
		endm 
	;}
;}

;Key map
mouseLClick equ 01
