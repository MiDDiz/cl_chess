# ====================================
# Methods for playing specific pieces
# ==================================== 
module Chess

	private
	
	def play_knight(from, to)
		from[1] != to[1] ? place_piece(from, to) : raise_invalid_move
	end

	def play_others(from, to)
		square(from).class == Pieces::Rook ? castle(from, to) : place_piece(from, to)
	end

	def play_pawn(from, to)
		if [-7,-9,7,9].any? { |m| calc_move(from, m) == to } && square(from).white != square(to).white
			pick_pawn_action(from, to)
		elsif square(from).legal_move?(from, to) && square(to) == " "
			(to[1].ord - from[1].ord).abs == 2 ? play_pawn_by_two(from, to) : pick_pawn_action(from, to)
		else
			raise_invalid_move
		end
	end

	def play_pawn_by_two(from, to)
		if to[1].ord - from[1].ord == 2 && square(calc_move(from, 8)) == " "
			pick_pawn_action(from, to)
		elsif to[1].ord - from[1].ord == -2 && square(calc_move(from, -8)) == " "
			pick_pawn_action(from, to)
		else
			raise_invalid_move
		end
	end

	def pick_pawn_action(from, to)
		to[1] == '1' || to[1] == '8' ? promote(from, to) : place_piece(from, to)
	end
end