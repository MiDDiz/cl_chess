# COMMAND-LINE CHESS

Prepared for The Odin Project's Ruby Final Project

### In order to play, run `ruby start_game.rb` in your terminal.

## Complete with all the special moves (en passant, castling, promotion)
	
* You will be prompted if you want to castle or do en passant when the correct situation occurs.
If your response is no(`n`), your regular move will be played. If your response is yes(`y`), then
the appropriate move will be played.
* When the appropriate situation for promotion occurs, you will be prompted to type the piece you
want your pawn to be promoted. Options are Pawn, Bishop, Knight, Rook, and Queen.

## Complete with checkmate and stalemate

* The game automatically ends when it is a checkmate or a stalemate.

## With an option to save the game:

* In order to save and quit the game, type `save` when you are prompted for your moves.
* Saved game file name is composed of the names of the players: e.g. *Shala_vs_Zahra.txt*
* If there already is a saved game, you will be asked if you want to load it or not at the start of a new game.
* If your response is yes(`y`), then you will be prompted to type the names of the players
and the game will load. If there is no such saved game, then a new game will start.

## 2-Player game over network connection

When you pick the option to play over a network, a server will fire up at port 2000 on your localhost. When another computer on the network runs `ruby join_game.rb your_ip_address`, a game will start. The connecting computer doesn't need to have the whole game script. If a game doesn't start, your firewall might be blocking incoming requests. Make sure to make the necessary adjustments.

## Also with a simple AI
	
* Makes random legal moves

# TO BE ADDED:

* Tests

PLEASE: Let me know if there are any bugs you notice!