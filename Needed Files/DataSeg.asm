;print vars{
	filename db 11 dup (0)
	filehandle dw ?
	Header db 54 dup (0)
	Palette db 256*4 dup (0)
	ScrLine db 320 dup (0)
;}

;game{
	;the index of the card, six letters of file deceleration, actual value 
	allCards db 1, 'T', 'w', 'o', 'D', 'R', 'C', 2   ;two diamond
			 db	2, 'T', 'w', 'o', 'L', 'B', 'C', 2   ;two leaf
			 db	3, 'T', 'w', 'o', 'H', 'R', 'C', 2   ;two heart
			 db	4, 'T', 'w', 'o', 'C', 'B', 'C', 2   ;two clover
			 db	5, 'T', 'h', 'r', 'D', 'R', 'C', 3   ;three diamond
			 db	6, 'T', 'h', 'r', 'L', 'B', 'C', 3   ;three leaf
			 db	7, 'T', 'h', 'r', 'H', 'R', 'C', 3   ;three heart
			 db	8, 'T', 'h', 'r', 'C', 'B', 'C', 3   ;three clover
			 db	9, 'F', 'o', 'u', 'D', 'R', 'C', 4   ;four diamond
			 db	10, 'F', 'o', 'u', 'L', 'B', 'C', 4  ;four leaf
			 db	11, 'F', 'o', 'u', 'H', 'R', 'C', 4  ;four heart
			 db	12, 'F', 'o', 'u', 'C', 'B', 'C', 4  ;four clover
			 db	13, 'F', 'i', 'v', 'D', 'R', 'C', 5  ;five diamond
			 db	14, 'F', 'i', 'v', 'L', 'B', 'C', 5  ;five leaf
			 db	15, 'F', 'i', 'v', 'H', 'R', 'C', 5  ;five heart
			 db 16, 'F', 'i', 'v', 'C', 'B', 'C', 5  ;five clover
			 db 17, 'S', 'i', 'x', 'D', 'R', 'C', 6  ;six diamond
			 db 18, 'S', 'i', 'x', 'L', 'B', 'C', 6  ;six leaf
			 db 19, 'S', 'i', 'x', 'H', 'R', 'C', 6  ;six heart
			 db 20, 'S', 'i', 'x', 'C', 'B', 'C', 6  ;six clover
			 db 21, 'S', 'e', 'v', 'D', 'R', 'C', 7  ;seven diamond
			 db 22, 'S', 'e', 'v', 'L', 'B', 'C', 7  ;seven leaf
			 db 23, 'S', 'e', 'v', 'H', 'R', 'C', 7  ;seven heart
			 db 24, 'S', 'e', 'v', 'C', 'B', 'C', 7  ;seven clover
			 db 25, 'E', 'i', 'g', 'D', 'R', 'C', 8  ;eight diamond
			 db 26, 'E', 'i', 'g', 'L', 'B', 'C', 8  ;eight leaf
			 db 27, 'E', 'i', 'g', 'H', 'R', 'C', 8  ;eight heart
			 db 28, 'E', 'i', 'g', 'C', 'B', 'C', 8  ;eight clover
			 db 29, 'N', 'i', 'n', 'D', 'R', 'C', 9  ;nine diamond
			 db 30, 'N', 'i', 'n', 'L', 'B', 'C', 9  ;nine leaf
			 db 31, 'N', 'i', 'n', 'H', 'R', 'C', 9  ;nine heart
			 db 32, 'N', 'i', 'n', 'C', 'B', 'C', 9  ;nine clover
			 db 33, 'T', 'e', 'n', 'D', 'R', 'C', 10 ;ten diamond
			 db 34, 'T', 'e', 'n', 'L', 'B', 'C', 10 ;ten leaf
			 db 35, 'T', 'e', 'n', 'H', 'R', 'C', 10 ;ten heart
			 db 36, 'T', 'e', 'n', 'C', 'B', 'C', 10 ;ten clover
			 db 37, 'J', 'u', 'n', 'D', 'R', 'C', 11 ;prince diamond
			 db 38, 'J', 'u', 'n', 'L', 'B', 'C', 11 ;prince leaf
			 db 39, 'J', 'u', 'n', 'H', 'R', 'C', 11 ;prince heart
			 db 40, 'J', 'u', 'n', 'C', 'B', 'C', 11 ;prince clover
			 db 41, 'Q', 'u', 'e', 'D', 'R', 'C', 12 ;queen diamond
			 db 42, 'Q', 'u', 'e', 'L', 'B', 'C', 12 ;queen leaf
			 db 43, 'Q', 'u', 'e', 'H', 'R', 'C', 12 ;queen heart
			 db 44, 'Q', 'u', 'e', 'C', 'B', 'C', 12 ;queen clover
			 db 45, 'K', 'i', 'n', 'D', 'R', 'C', 13 ;king diamond
			 db 46, 'K', 'i', 'n', 'L', 'B', 'C', 13 ;king leaf
			 db 47, 'K', 'i', 'n', 'H', 'R', 'C', 13 ;king heart
			 db 48, 'K', 'i', 'n', 'C', 'B', 'C', 13 ;king clover
			 db 49, 'A', 'c', 'e', 'D', 'R', 'C', 14 ;ace diamond
			 db	50, 'A', 'c', 'e', 'L', 'B', 'C', 14 ;ace leaf
			 db	51, 'A', 'c', 'e', 'H', 'R', 'C', 14 ;ace heart
			 db	52, 'A', 'c', 'e', 'C', 'B', 'C', 14 ;ace clover

	myStack dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	opponentStack dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	isCardGotSplited dw false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false
				dw false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false
				dw false, false, false, false, false, false, false
	
	myCurrentCards dw 0, 0, 0, 0, 0; five slots for max current cards
	opponentCurrentCards dw 0, 0, 0, 0, 0 ;five slots for max current cards	
	
	myCurrentCardIndex dw 0, 0, 0, 0, 0
	opponentCurrentCardIndex dw 0, 0, 0, 0, 0
	
	gameOver db 0
;}
