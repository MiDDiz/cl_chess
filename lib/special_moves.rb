module SpecialMoves

	def promote(from, to)
		@output.puts "Pick a piece you would like to promote your pawn to:"
		piece = @input.gets.chomp.downcase.capitalize
		if %w[Pawn Bishop Rook Knight Queen].include?(piece)
			case piece
			when "Pawn" then piece = square(from).white ? Pieces::Pawn.new(true) : Pieces::Pawn.new
			when "Bishop" then piece = square(from).white ? Pieces::Bishop.new(true) : Pieces::Bishop.new
			when "Rook" then piece = square(from).white ? Pieces::Rook.new(true) : Pieces::Rook.new
			when "Knight" then piece = square(from).white ? Pieces::Knight.new(true) : Pieces::Knight.new
			when "Queen" then piece = square(from).white ? Pieces::Queen.new(true) : Pieces::Queen.new
			end
			@board.board[to] = piece
			@board.board[from] = " "
		else
			promote(from, to)
		end
	end

	def castle (from, to)
		unless square(from).moved && check?(@board.board)
			if square(calc_move(to, 1)).class == Pieces::King && !square(calc_move(to, 1)).moved
				place_piece(from, to)
				place_piece(calc_move(to, 1), calc_move(from, 2)) if choose_castling?
			elsif square(calc_move(to, -1)).class == Pieces::King && !square(calc_move(to, -1)).moved
				place_piece(from, to)
				place_piece(calc_move(to, -1), calc_move(from, -1)) if choose_castling?
			else
				place_piece(from, to)
			end
		else
			place_piece(from, to)
		end
	end

	def choose_castling?
		@output.puts "Would you like to castle?(y/n):"
		return @comp ? ai_pick : human_pick
	end

	def set_en_passant_turn(from, to)
		if (calc_move(from, 16) == to || calc_move(from, -16) == to) && (square(from).class == Pieces::Pawn && !square(from).moved)
			square(from).en_passant_valid = true
			@en_passant_turns = @turns
		elsif square(from).class == Pieces::Pawn
			square(from).en_passant_valid = false
		end
	end

	def en_passant(from, to)
		if square(to).class == Pieces::Pawn && (square(to).en_passant_valid && @turns - @en_passant_turns == 1)
			if square(calc_move(to, 1)).class == Pieces::Pawn && square(to).white != square(calc_move(to, 1)).white
				do_en_passant(from, to, 1) if to[1] == calc_move(to, 1)[1]
			elsif square(calc_move(to, -1)).class == Pieces::Pawn && square(to).white != square(calc_move(to, -1)).white
				do_en_passant(from, to, -1) if to[1] == calc_move(to, -1)[1]
			else
				square(to).en_passant_valid = false
			end
		end
	end

	def do_en_passant(from, to, step)
		spot = from[1] < to[1] ? 8 : -8
		if choose_en_passant?
			square(to).en_passant_valid = false
			@board.board[to] = " "
			@board.board[calc_move(from, spot)] = @board.board[calc_move(to, step)]
			@board.board[calc_move(to, step)] = " "
			@board.display(STDOUT)
			@board.display(@stream) if @on_network
			turn
			switch_stream
		end
	end

	def choose_en_passant?
		show_whose_turn
		@output.puts "\nWould you like to do 'en passant'?:"
		@comp ? ai_pick : human_pick
	end
end			