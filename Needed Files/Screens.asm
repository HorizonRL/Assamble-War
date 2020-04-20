;Menu{
	macro WAR
		FileTransfer 'w' 'a' 'r' 'G' 'G' 'G'
		EndOfScreenDecleratoion
		PRINT_BMP
	endm

	macro OFEK_RL
		FileTransfer 'o' 'f' 'e' 'k' 'R' 'L'
		EndOfScreenDecleratoion
		PRINT_BMP
	endm

	macro MAIN_OPEN_SCREEN
		FileTransfer 'h' 'o' 'm' 'e' 'S' 'c'
		EndOfScreenDecleratoion
		PRINT_BMP
	endm

	macro MAIN_OPEN_SCREEN_PLAY
		FileTransfer 'h' 'm' 'P' 'l' 'a' 'y'
		EndOfScreenDecleratoion
		PRINT_BMP
	endm

	macro MAIN_OPEN_SCREEN_INFO
		FileTransfer 'h' 'm' 'I' 'n' 'f' 'o'
		EndOfScreenDecleratoion
		PRINT_BMP
	endm

	macro MAIN_OPEN_SCREEN_EXIT
		FileTransfer 'h' 'm' 'E' 'x' 'i' 't'
		EndOfScreenDecleratoion
		PRINT_BMP
	endm

	macro INFO_SCREEN
		FileTransfer 'i' 'n' 'f' 'o' 'S' 'c'
		EndOfScreenDecleratoion
		PRINT_BMP
	endm

	macro INFO_SCREEN_ESC
		FileTransfer 'i' 'n' 'f' 'E' 's' 'c'
		EndOfScreenDecleratoion
		PRINT_BMP
	endm
;}

;game{
	macro GAME_FIELD
		FileTransfer 'g' 'a' 'm' 'e' 'F' 'd'
		EndOfScreenDecleratoion
		PRINT_BMP
	endm

	macro ESC_NOT_PRESSED
		FileTransfer 'E' 's' 'c' 'b' 'n' 'p'
		EndOfScreenDecleratoion
		PRINT_BMPByPosition
	endm

	macro ESC_IS_PRESSED
		FileTransfer 'E' 's' 'c' 'b' 'i' 'p'
		EndOfScreenDecleratoion
		PRINT_BMPByPosition
	endm

	macro WINNER_CROWN
		FileTransfer 'c' 'r' 'o' 'w' 'n' 'P'
		EndOfScreenDecleratoion
		PRINT_BMPByPosition
	endm

	macro FINAL_WINNER_CROWN
		FileTransfer 'w' 'i' 'n' 'C' 'r' 'w'
		EndOfScreenDecleratoion
		PRINT_BMPByPosition
	endm

	macro BLANK_BACKGROUND
		FileTransfer 'b' 'l' 'a' 'n' 'k' 'B'
		EndOfScreenDecleratoion
		printToBlankBG
		PRINT_BMPByPosition
	endm
;}

;cards{
	macro STACK_CARD
		FileTransfer 'S' 't' 'a' 'c' 'k' 'C'
		EndOfScreenDecleratoion
		PRINT_BMPByPosition
	endm

;}

macro FileTransfer  firstLetter, secondLetter, thiredLetter, fourtLetter, fivethLetter, sixthLetter
		mov [filename], firstLetter
		mov [filename + 1], secondLetter
		mov [filename + 2], thiredLetter
		mov [filename + 3], fourtLetter
		mov [filename + 4], fivethLetter
		mov [filename + 5], sixthLetter
endm FileTransfer

macro EndOfScreenDecleratoion
		mov [filename + 6],'.'
		mov [filename + 7],'b'
		mov [filename + 8],'m'
		mov [filename + 9],'p'
		mov [filename + 10],0
endm EndOfScreenDecleratoion