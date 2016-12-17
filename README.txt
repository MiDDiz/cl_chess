
* Making a move
	When you are prompted for making your move, enter it as 'from to' combination.
	For example, 'a4 a5'.

* Promoting a piece
	When the appropriate situation for promotion occurs, you will be prompted to type
	the piece you want your pawn to be promoted. Options are Pawn, Bishop, Knight, Rook,
	and Queen.

* Castling and En Passant
	You will be prompted if you want to castle or do en passant when the correct situation
	occurs. If your response is no('n'), your regular move will be played. If your response
	is yes('y'), then the appropriate move will be played.

* Saving a game
	Type 'save' when you are prompted for making a move. The name of  saved game 
	file consists of the names of the players. For example, 'Zahra_vs_Shala.txt'.
	A folder named 'saves' will be created if it has not been already.

* Loading a game
	If you wish to continue a saved game, you will be prompted to enter the names of 
	the players of that saved game. If no such saved game is present, a new game will 
	be started.

* Playing over a network
	When you pick the option to play over a network, a server will fire up at port 2000
	on your localhost. When another computer on the network runs 'ruby join_game.rb 
	your_ip_address', a game will be started. The connecting computer doesn't need to have
	the whole game script. If a game doesn't start, your firewall might be blocking incoming
	requests. Make sure to make the necessary adjustments.

* Playing with the computer
	Makes random legal moves

==================================================================================================

