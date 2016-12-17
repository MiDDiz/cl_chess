module InitialTurn
	
	def initialize_game
		@comp ? play_with_comp : play_with_human
		set_player_name
		set_board
		show_board
		start_turn
	end

	def set_player_name
		unless @comp
			@player_1.get_name(STDOUT, STDIN)
			@player_2.get_name(@output, @input)
		else
			@player_1.get_name(@output, @input)
		end
	end

	def play_with_human
		@player_1 = Players::Human.new(true)
		@player_2 = Players::Human.new
	end

	def play_with_comp
		@player_1 = Players::Human.new(true)
		@player_2 = Players::AI.new
	end

	def set_current_player
		@player = @turns.odd? ? @player_2 : @player_1
	end

	def set_board
		keys = @board.board.keys
		keys[0..15].each { |key| @board.board[key] = @player_1.pieces.shift }
		keys[56..63].each { |key| @board.board[key] = @player_2.pieces.shift }
		keys[48..55].each { |key| @board.board[key] = @player_2.pieces.shift }
	end
end