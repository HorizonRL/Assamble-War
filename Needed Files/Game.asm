macro MakeAturn
	call TakeACardFromMy
	RANDOM_DELAY
	call TakeACardFromOpponent ;this is the pronblemo
	DELAY_SHORT
	call MakeTheTransfer
	DELAY_SHORT
	BLANK_BACKGROUND
endm 
;---------------------------------------------------------------;
proc Game
	push bp 
	mov bp ,sp
	;need to pop before ret
	NewSlotStack;to use is
	GAME_FIELD
	jmp regEscPrint

checkSections:
escCheck:
	call GetMouseData 
	pushCords inGameEscXL inGameEscXR inGameEscYB inGameEscYT
	call IsInBoundaries
	pop is 
	cmp is, true
	jne myCardStackCheck
	jmp printEscMouseHoverd
		
myCardStackCheck:
	pushCords myCardStackXL myCardStackXR myCardStackYB myCardStackYT
    call IsInBoundaries
	pop is 
	cmp is, true
	jne checkSections
	NewSlotStack
	call GetMouseData
	call IsMouseClick
	pop is 
	cmp is, true
	jne myCardStackCheck
	MakeAturn
	jmp checkSections

printEscMouseHoverd:
	printToESC
	ESC_IS_PRESSED
	jmp checkIfEscPressed
	
checkIfEscPressed:
	call GetMouseData
	pushCords inGameEscXL inGameEscXR inGameEscYB inGameEscYT
    call IsInBoundaries
	pop is 
	cmp is, true
	jne regEscPrint
	NewSlotStack
	call IsMouseClick
	pop is 
	cmp is, true
	jne checkIfEscPressed
	jmp escGameToMenu

regEscPrint:
	printToESC
	ESC_NOT_PRESSED
	jmp checkSections

escGameToMenu:
	pop ax 
	pop bp
	ret
endp Game
;---------------------------------------------------------------;
MaxRandom equ [bp + 6]
MinRandom equ [bp + 4]
RandomNumberOutput equ [bp + 6]
proc Random
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	
	mov ah, 2Ch
	int 21h ;get time data from system
	xor ax, ax
	mov al,dl; mSec in dl
	xor dx, dx
	mov bx, MaxRandom
	inc bx
	sub bx, MinRandom
	div bx
	mov cx, MinRandom
	cmp cx, 0
	je finishRandom
AdjustMinRandom:
	inc dl
	loop AdjustMinRandom
finishRandom:
	mov RandomNumberOutput, dl
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 2
endp Random
;---------------------------------------------------------------;
indexCounter equ [word ptr bp - 2]
myS equ [word ptr bp - 4]
opS equ [word ptr bp - 6]
isFinish equ [word ptr bp - 8]
boolA equ [word ptr bx]
proc SplitCards
	push bp
	mov bp, sp
	NewSlotStack
	NewSlotStack
	NewSlotStack
	NewSlotStack
	push ax
	push si 
	push cx
	
	WAR;intro
	mov opS, offset opponentStack
	mov bx, offset isCardGotSplited
	mov myS, offset myStack
	mov si, myS
	
	
loopIt:
	mov cx, 26
splitCardLoop:
RandomrandequnewRandom:
	makeARandomSplit	
	pop ax ;random num
	
	push bx
	add bx, ax ;add bx 2 times  ax
	add bx, ax
	cmp boolA, true
	pop bx
	je RandomrandequnewRandom
	push bx
	push ax
	add bx, ax ;add bx 2 times  ax
	add bx, ax
	mov boolA, true
	pop ax
	pop bx
	
	push si
	add si, indexCounter
	mov [si], ax
	mov ax, [word ptr si]
	pop si
	
	add indexCounter, 2	
	loop splitCardLoop
	
    cmp isFinish, true
	je finishSplit
	OFEK_RL;intro
	mov isFinish, true	
	mov indexCounter, 0
	mov si, opS
	jmp loopIt
	
finishSplit:
	pop ax	
	pop ax
	pop ax
	pop ax
    pop cx
	pop si 
	pop ax 
	pop bp
	ret 
endp SplitCards
;;----------------------------------------------;
whatCardToPrint equ [bp + 6]
whatStack equ [word ptr bp + 4] ;true my, false opponent, eqalsMy, eqalsOpponent
isWantedToDelay equ [word ptr bp - 2] ; at war state is false
proc PrintCard
	push bp 
	mov bp, sp
	push bx
	push ax
	push si
	NewSlotStack
	
	mov ax, whatCardToPrint
	
	push cardResH
	push cardResW
	cmp whatStack, true ;my
	je placeInMy
	cmp whatStack, false ;opponent
	je placeInOpponent
	cmp whatStack, warStateMy ;eqalsMy
	je placeInMyAtWar
	jmp placeInOpponentAtWar
	
	
placeInMy:
	printToMyCurrntCards
	jmp findAndPrint
	
placeInOpponent:
	printToOpponentCurrntCards
	jmp findAndPrint
	
placeInMyAtWar:
	printToMyCurrntCardsFourthWarState
	mov isWantedToDelay, false
	jmp findAndPrint
	
placeInOpponentAtWar:
	printToOpponentCurrntCardsFourthWarState
	mov isWantedToDelay, false
	jmp findAndPrint

findAndPrint:
	mov bl, 8
	mov al, whatCardToPrint
	dec al
	mul bl
	mov bx, ax
	
	inc bx
	mov al, [allCards + bx]
	mov [filename],al
	
	inc bx
	mov al, [allCards + bx]
	mov [filename + 1],al
	
	inc bx
	mov al, [allCards + bx]
	mov [filename + 2],al
	
	inc bx
	mov al, [allCards + bx]
	mov [filename + 3],al
	
	inc bx
	mov al, [allCards + bx]
	mov [filename + 4],al
	
	inc bx
	mov al, [allCards + bx]
	mov [filename + 5],al

	EndOfScreenDecleratoion
	PRINT_BMPByPosition	
	cmp isWantedToDelay, true
	jne finishPrintCard
	DELAY_VERY_SHORT
	
finishPrintCard:
	pop ax
	pop si
	pop ax
	pop bx 
	pop bp
	ret 4
endp PrintCard
;---------------------------------------------------------------;
proc TakeACardFromMy	
	StartFunction

randMyCards:
	makeARandomCardIndex
	pop si
	mov ax, si
	add si, ax ;mul 2
	cmp [word ptr myStack + si], 0 ; invalid value (empty slots)
	je randMyCards
	mov [word ptr myCurrentCardIndex + 8], si;for future card trans
	
	mov ax, [word ptr myStack + si]
	mov [word ptr myCurrentCards + 8], ax ;value
	push ax
	push true
	call PrintCard
	
	EndFunction
	ret
endp TakeACardFromMy
;---------------------------------------------------------------;
proc TakeACardFromOpponent
	StartFunction
randOpponentCards:
	makeARandomCardIndex
	pop si
	mov ax, si
	add si, ax
	cmp [word ptr opponentStack + si], 0 ; invalid value (empty slots)
	je randOpponentCards
	mov [word ptr opponentCurrentCardIndex + 8], si ; for future card trans
	
	mov ax, [word ptr opponentStack + si]
	mov [word ptr opponentCurrentCards + 8], ax	
	push ax
	push false
	call PrintCard
	

	EndFunction
	ret
endp TakeACardFromOpponent
;---------------------------------------------------------------;
whatCardTofind equ [bp + 4]
res equ [word ptr bp + 4]                                       
proc FindActualValue                                            
	push bp                                                     
	mov bp, sp                                                  
	push ax  
	
	mov bl, 8
	mov al, whatCardTofind
	dec al
	mul bl
	add ax, 7
	mov bx, ax
	mov al, [allCards + bx]
	xor ah, ah
	mov res, ax 
	pop ax                                                      
	pop bp                                                      
	ret                                                         
endp FindActualValue                                            
;---------------------------------------------------------------;
myCurrentCardActualValue equ [word ptr bp - 2]
WhoWon equ [word ptr bp + 4]
currentCardsIndexForCalac equ [word ptr bp + 4]
proc WhoWins
	push bp
	mov bp, sp
	push ax
	NewSlotStack; for myCurrentCardActualValue
	push si
	
	mov si, currentCardsIndexForCalac
	
	;calc the index for my actual value
	
	push [myCurrentCards + si]
	call FindActualValue
	pop myCurrentCardActualValue
	
	;calc the index for opponent actual value
	push [opponentCurrentCards + si]
	call FindActualValue
	pop ax
	
	cmp myCurrentCardActualValue, ax
	ja myTurnWin
	cmp myCurrentCardActualValue, ax
	jb opponentTurnWin
	jmp equalCards
	
myTurnWin:
	mov WhoWon, true
	printToMyCrown
	jmp printCrownAtPos
	
opponentTurnWin:
	mov WhoWon, false
	printToOpponentCrown
	jmp printCrownAtPos
		
equalCards:
	mov WhoWon, equalCardsState
	jmp finishWhoWins
	
printCrownAtPos:
	WINNER_CROWN
	jmp finishWhoWins
finishWhoWins:
	pop si
	pop ax
	pop ax
	pop bp
	ret 
endp WhoWins
;---------------------------------------------------------------;
currents equ [word ptr bp + 4]  ;                                
randomizedCard equ [word ptr bp + 6]
isNumValid equ [word ptr bp + 6]
currentsIndex equ [word ptr bp - 2]
proc IsValid
	StartFunction
	NewSlotStack ;for using currentsIndex
	
	mov currentsIndex, 8
	mov si, randomizedCard
	add si, randomizedCard
	
	cmp currents, offset myCurrentCards
	je myCardIndexHandler
	jmp opponentCardIndexHandler
	
myCardIndexHandler:
	cmp [word ptr myStack + si], 0
	je notValid
myValidetion:
	mov di, currents
	add di, currentsIndex
	push ax;{
	mov ax, [di]
	cmp [word ptr myStack + si], ax
	pop ax;}
	je notValid
	cmp currentsIndex, 0
	je valid
	sub currentsIndex,2
	jmp myValidetion
	
	
opponentCardIndexHandler:
	cmp [word ptr opponentStack + si], 0
	je notValid
opponentValidetion:
	mov di, currents
	add di, currentsIndex
	push ax;{
	mov ax, [di]
	cmp [word ptr opponentStack + si], ax
	pop ax;}
	je notValid
	cmp currentsIndex, 0
	je valid
	sub currentsIndex,2
	jmp opponentValidetion
	
notValid:
	mov isNumValid, false
	jmp finishIsValid

valid:
	mov isNumValid, true
	jmp finishIsValid

finishIsValid:
	pop ax
	EndFunction
	ret 2
endp IsValid
;---------------------------------------------------------------;
whatStackIsIt equ [word ptr bp + 4]
indexValue equ [word ptr bp + 6]
slotIndex equ [word ptr bp + 6]
proc GetCardIndexValue
	StartFunction
	
	mov si, indexValue
cmpStacks:
	cmp whatStackIsIt, true 
	je myIndex
	jmp opponentIndex
myIndex:
	mov ax, [word ptr myStack + si]
	mov slotIndex, ax
	jmp finishGetCardIndexValue
	
opponentIndex:
	mov ax, [word ptr opponentStack + si]
	mov slotIndex, ax
	jmp finishGetCardIndexValue

finishGetCardIndexValue:
	EndFunction
	ret 2
endp GetCardIndexValue
;---------------------------------------------------------------;
isFinished equ [word ptr bp - 4]
currentsIndexCounter equ [word ptr bp - 6]
randomCardIndexWar equ [word ptr bp - 8]
proc MakeRandomsForWarState
	StartFunction
	NewSlotStack ;for is
	NewSlotStack ;for isFinished
	NewSlotStack ;for currentsIndexCounter
	NewSlotStack ;for randomCardIndexWar
	
	mov di, offset myCurrentCardIndex
	mov si, offset myCurrentCards
	mov dx, true
initLoop:
	mov cx, 4
	mov currentsIndexCounter, 6
randomizeWarStateCardsLoop:
randomizeWarStateCards:
	makeARandomCardIndex
	pop ax

	push ax;{
	push ax
	push si
	call IsValid
	pop is
	pop ax;}
	cmp is, true
	jne randomizeWarStateCards
	
	mov bx, ax
	add ax, bx; mul by 2
	mov bx, currentsIndexCounter
	mov [di + bx], ax
	
	push ax
	push dx	
	call GetCardIndexValue
	pop ax
	mov bx, currentsIndexCounter
	mov [si + bx], ax
	
	sub currentsIndexCounter, 2
	loop randomizeWarStateCardsLoop
	cmp isFinished, true
	je finishMakeRandomsForWarState
	
	mov isFinished, true
	mov di, offset opponentCurrentCardIndex
	mov si, offset opponentCurrentCards
	mov dx, false
	jmp initLoop

finishMakeRandomsForWarState:
	pop ax
	pop ax
	pop ax
	pop ax
	EndFunction
	ret 
endp MakeRandomsForWarState
;---------------------------------------------------------------;
macro PRINT_WAR_STATE
	
	printToMyCurrntCardsFirstWarState
	STACK_CARD
	printToOpponentCurrntCardsFirstWarState
	STACK_CARD
	DELAY_SHORT
	
	printToMyCurrntCardsSecWarState
	STACK_CARD
	printToOpponentCurrntCardsSecWarState
	STACK_CARD
	DELAY_SHORT
	
	printToMyCurrntCardsThirdWarState
	STACK_CARD
	printToOpponentCurrntCardsThirdWarState
	STACK_CARD
	DELAY_SHORT
	
	printToMyCurrntCardsFourthWarState
	push [myCurrentCards + 0]
	push warStateMy
	call PrintCard
	
	printToOpponentCurrntCardsFourthWarState
	push [opponentCurrentCards + 0]
	push warStateOpponent
	call PrintCard
endm
;---------------------------------------------------------------;
proc TransferAtWarState
	StartFunction
	NewSlotStack ;for using is
	
	xor ax, ax
	xor di, di; default value
	
checkWarState:
	push ax;index to use currents
	call WhoWins
	pop is
	cmp is, true
	je preIWonTheWarState
	cmp is, false
	jne continueCheckWarState
	jmp preOpponentWonTheWarState
	
continueCheckWarState:
	add ax, 2
	jmp checkWarState

preIWonTheWarState:
	xor di, di; default value
	mov cx, 5
iWonTheWarState:
	
	push offset myStack
	call FindEmptySlots
	pop si
	cmp si, thereAreNoZero
	je imFinalWinner
	
	mov ax,[opponentCurrentCards + di]
	mov [word ptr si], ax; move new card to empty slot
	
	mov [opponentCurrentCards + di], 0;currents zero it
	
	mov si, [opponentCurrentCardIndex + di]
	mov [opponentStack + si], 0; lost card equ zero
	
	add di, 2
	loop iWonTheWarState
	jmp finishWarStateHandler
	
imFinalWinner:
	I_AM_THE_WINNER
	jmp gameOverStateAtWar
	
preOpponentWonTheWarState:
	printToOpponentCrown
	WINNER_CROWN
	xor di, di; default value
	mov cx, 5
opponentWonTheWarState:
	push offset opponentStack
	call FindEmptySlots
	pop si
	cmp si, thereAreNoZero
	je opponentFinalWinner
	
	mov ax,[myCurrentCards + di]
	mov [word ptr si], ax; move new card to empty slot
	
	mov [myCurrentCards + di], 0;currents zero it
	
	mov si, [myCurrentCardIndex + di]
	mov [myStack + si], 0; lost card equ zero
	
	add di, 2
	loop opponentWonTheWarState
	jmp finishWarStateHandler

opponentFinalWinner:
	OPPONENT_IS_THE_WINNER
	jmp gameOverStateAtWar

gameOverStateAtWar:
	mov [gameOver], true
	jmp finishWarStateHandler
	
finishWarStateHandler:
	pop ax
	EndFunction
	ret
endp TransferAtWarState
;---------------------------------------------------------------;
proc WarStateHandler
	call MakeRandomsForWarState
	PRINT_WAR_STATE
	pop ax
	pop ax
	pop ax
	pop ax
	call TransferAtWarState
	ret
endp WarStateHandler
;---------------------------------------------------------------;
arrIndex equ [word ptr bp + 4]; will ret the first 0 index, or thereAreNoZero
whatArr equ [word ptr bp + 4]
proc FindEmptySlots
	StartFunction
	
	xor ax, ax
	mov si, whatArr
	mov cx, 52
zeroFinder:
	push si
	add si, ax
	cmp [word ptr si], 0
	pop si
	je foundAZero
	
	add ax, 2
	loop zeroFinder
	jmp notFoundAZero
foundAZero:
	add si, ax
	mov whatArr, si
	jmp finishFindEmptySlots
	
notFoundAZero:
	mov arrIndex, thereAreNoZero
	jmp finishFindEmptySlots
	
finishFindEmptySlots:
	EndFunction
	ret
endp FindEmptySlots
;---------------------------------------------------------------;
proc MakeTheTransfer
	StartFunction
	NewSlotStack ;to use is;{
	
findTransfer:
	push NotWar;index of currents top use
	call WhoWins
	pop is
	cmp is, true
	je currentStateMy
	cmp is, false
	je currentStateOpponent
	jmp currentStateWar
	
currentStateMy:
	push offset myStack
	call FindEmptySlots
	pop si 
	cmp si, thereAreNoZero
	je iAmfinalWinner
	mov ax, [word ptr opponentCurrentCards + 8]
	mov [word ptr si], ax; transfer opp card to my stack
	mov si, [word ptr opponentCurrentCardIndex + 8]
	mov [word ptr opponentStack + si], 0; move zero to the transfered card index at opp
	jmp finishMakeTrans

currentStateOpponent:
	push offset opponentStack
	call FindEmptySlots
	pop si 
	cmp si, thereAreNoZero
	jne continueCurrentStateOpponent
	jmp opponentIsfinalWinner
continueCurrentStateOpponent:
	mov ax, [word ptr myCurrentCards + 8]
	mov [word ptr si], ax; transfer my card to opp stack
	mov si, [word ptr myCurrentCardIndex + 8]
	mov [word ptr myStack + si], 0; move zero to the transfered card index at my	
	jmp finishMakeTrans
	
iAmfinalWinner:
	OPPONENT_IS_THE_WINNER
	jmp gameOverState
	
opponentIsfinalWinner:
	I_AM_THE_WINNER
	jmp gameOverState 

currentStateWar:
	call WarStateHandler
	jmp finishMakeTrans

gameOverState:
	mov [gameOver], true
	jmp finishMakeTrans
	
finishMakeTrans:
	pop ax;}
	EndFunction
	ret
endp MakeTheTransfer
;---------------------------------------------------------------;
resetSatge equ [word ptr bp - 2]
proc GameOverHandler
	StartFunction
	NewSlotStack; for resetSatge
	
	mov si, offset myStack
	mov resetSatge, 1
	
initResetLoopForStack:
	xor ax, ax
	mov cx, 51
	jmp resetGame

initResetLoopForCardIndexs:
	xor ax, ax
	mov cx, 5
	jmp resetGame
	
resetGame:
	push si
	
	add si, ax
	mov si, 0
	
	pop si
	
	add ax, 2
	loop resetGame

continueReset:	
	cmp resetSatge, 1
	je stage2
	cmp resetSatge, 2
	je stage3
	cmp resetSatge, 2
	je stage4
	jmp finishGameOverHandler

stage2:
	mov resetSatge, 3 
	mov si, offset opponentStack
	jmp initResetLoopForStack
	
stage3:
	mov resetSatge, 4 
	mov si, offset opponentCurrentCardIndex
	jmp initResetLoopForCardIndexs
	
stage4:	
	mov resetSatge, 5
	mov si, offset myCurrentCardIndex
	jmp initResetLoopForCardIndexs
	
finishGameOverHandler:
	pop ax; for resetSatge
	EndFunction
	ret
endp GameOverHandler
