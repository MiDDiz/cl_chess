# ==================================================
# Methods related to check, checkmate and stalemate
# ==================================================
module Chess

	private
	
	# Checks if the current move of the current player causes a check position against itself
	def getting_into_check?(from, to)
		return check?(clone_board(from, to))
	end

	# Checks if any valid move of any of the opponent's pieces reaches the current player's king
	def check?(board)
		pieces = board.select { |square, piece| piece.class != String && piece.white != @player.white }
		king = board.select { |square, piece| piece.class == Pieces::King && piece.white == @player.white }.keys[0]
		pieces.each do |from, piece|
			if board[from].class == Pieces::Pawn && [-7,-9,7,9].any? { |t| calc_move(from, t) == king }
				return true
			elsif board[from].legal_move?(from, king)
				if board[from].class == Pieces::Knight && from[1] != king[1]
					return true
				elsif board[from].class != Pieces::Pawn && board[from].legal_list(from, king).all? { |t| board[t] == " " }
					return true
				end
			end
		end
		return false
	end

	# Checks if the current player's king can move to get out of the current check position
	def movable?
		king = @board.board.select { |square, piece| piece.class == Pieces::King && piece.white == @player.white }.keys[0]
		[-1,-7,-8,-9,1,7,8,9].each do |spot| 
			if square(calc_move(king, spot)) == " " || square(king).white != square(calc_move(king, spot)).white 
				return true unless getting_into_check?(king, calc_move(king, spot))
			end
		end
		return false
	end

	# Checks if any valid move of any of the current player's pieces can interrupt the current check position
	def interruptable?
		pieces = @board.board.select { |square, piece| (piece.class != String && piece.class != Pieces::King) && piece.white == @player.white }
		king = @board.board.select { |square, piece| piece.class == Pieces::King && piece.white == @player.white }.keys[0]
		unless [Pieces::Pawn, Pieces::King, Pieces::Knight].include?(square(@to).class)
			check_route = square(@to).legal_list(@to, king) << @to
		else
			check_route = [@to]
		end
		pieces.each do |square, piece|
			if piece.white
				return true if piece.class == Pieces::Pawn && [7,9].any? { |t| calc_move(square, t) == @to }
			else
				return true if piece.class == Pieces::Pawn && [-7,-9].any? { |t| calc_move(square, t) == @to }
			end
			check_route.each do |r|
				if piece.legal_move?(square, r)
					if piece.class == Pieces::Pawn && square(r) == " "
						return true
					elsif piece.class == Pieces::Knight && square[1] != r[1]
						return true
					elsif piece.class != Pieces::Pawn && piece.legal_list(square, r).all? { |t| square(t) == " " }
						return true
					end
				end
			end
		end
		return false
	end

	def checkmate?
		return !movable? && !interruptable? if check?(@board.board)
	end

	# Check if the current player can make any valid moves
	def stalemate?
		pieces = @board.board.select { |square, piece| piece.class != String && piece.white == @player.white }
		peri = [-17,-15,-10,-9,-8,-7,-6,-1,1,6,7,8,9,10,15,17]
		pieces.each do |from, piece|
			peri.each do |to|
				if piece.legal_move?(from, calc_move(from, to)) && (square(calc_move(from, to)) == " " || square(calc_move(from, to)).white != @player.white)
					unless getting_into_check?(from, calc_move(from, to))
						if (piece.class == Pieces::Pawn && square(calc_move(from, to)) == " ") || piece.class == Pieces::King
							return false
						elsif piece.class == Pieces::Knight && from[1] != to[1]
							return false
						elsif piece.class != Pieces::Pawn && piece.legal_list(from, calc_move(from, to)).all? { |t| square(t) == " " }
							return false
						end
					end
				elsif piece.class == Pieces::Pawn && [7,9].any? { |t| calc_move(from, t) == to } && piece.white
					return false
				elsif piece.class == Pieces::Pawn && [-7,-9].any? { |t| calc_move(from, t) == to } && !piece.white
					return false
				end
			end
		end
		unless check?(@board.board)
			@stalemate = true
			return true
		end
	end
end