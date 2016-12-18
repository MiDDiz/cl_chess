# =================================
# Methods organizing the game flow
# =================================
module Chess

	private
	
	def start_turn
		begin
			loop do
				switch_stream
				set_current_player
				play_turn
				en_passant(@from, @to)
			end
		rescue Interrupt
			rescue_interrupt
		end
	end

	def play_turn
		game_over if (stalemate? || checkmate?) && @turns > 0
		show_whose_turn
		play_move
		show_comp_move
		turn
		show_board
	end

	def play_move
		check?(@board.board) ? when_in_check : get_move
		check_save_and_exit
		make_move
	end

	def when_in_check
		loop do
			@output.puts "You are in a check position. Please enter your move to get out of it." if @human || @turns.even?
			@player.get_move(@output, @input, @board.board)
			break unless getting_into_check?(@player.from, @player.to)
		end
		@to = @player.to
		@from = @player.from
	end

	def make_move
		begin
			unless valid_move?(@from, @to)
				raise_invalid_move
			end
			if correct_color?(@from)
				set_en_passant_turn(@from, @to)
				play_piece(@from, @to)
			else
				raise_invalid_move
			end
		rescue NoMethodError
			raise_invalid_input if @human || @turns.even?
			start_turn
		end
	end

	def play_piece(from, to)
		unless getting_into_check?(from, to)
			if square(from).class == Pieces::Pawn 
				play_pawn(from, to)
			elsif square(from).legal_move?(from, to)
				if square(from).class == Pieces::Knight
					play_knight(from, to)
				elsif square(from).class == Pieces::King || square(from).legal_list(from, to).all? { |n| square(n) == " " }
					play_others(from, to)
				else
					raise_invalid_move
				end
			else
				raise_invalid_move
			end
		else
			raise_invalid_move
		end
	end

	def place_piece(from, to)
		if square(to).class != Pieces::King
			@board.board[to] = square(from)
			square(to).moved = true
			@board.board[from] = " "
		else
			raise_invalid_move
		end
	end

	def game_over
		puts "\n\n\n"
		puts "======================"
		if @stalemate
			puts "IT'S A STALEMATE!"
		else
			puts @turns.odd? ? "CHECKMATE! WHITE WINS!" : "CHECKMATE! BLACK WINS!"
		end
		puts "======================"
		puts "\n\n\n"
		if @on_network
			@stream.puts "\n\n\n"
			@stream.puts "======================"
			if @stalemate
				@stream.puts "IT'S A STALEMATE!"
			else
				@stream.puts @turns.odd? ? "CHECKMATE! WHITE WINS!" : "CHECKMATE! BLACK WINS!"
			end
			@stream.puts "======================"
			@stream.puts "\n\n\n"
		end
		exit
	end
end