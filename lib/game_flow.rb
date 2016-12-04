module GameFlow
	def square(spot)
		spot = convert_to_key(spot) unless spot.class == Array
		return @board.board[spot.join.to_sym]
	end

	def turn
		@turns += 1
	end

	def whose_turn
		unless @is_invalid
			puts "\n#{@player_1.name} has the white pieces. #{@player_2.name} has the black pieces." if @turns.zero?
			puts @turns.odd? ? "\nIt is Black's turn!" : "\nIt is White's turn!"
		end
	end

	def show_move
		unless @is_invalid
			puts "From : #{@player_2.from.join unless @player_2.from.nil?}"
			puts "To   : #{@player_2.to.join unless @player_2.to.nil?}"
		end
	end

	def human_play
		@turns.odd? ? @player_2.make_move : @player_1.make_move
		@to = @turns.odd? ? @player_2.to : @player_1.to
		@from = @turns.odd? ? @player_2.from : @player_1.from
	end

	def ai_play
		unless @turns.odd?
			@player_1.make_move
			@to = @player_1.to
			@from = @player_1.from
		else
			@from = @player_2.ai_move_from(@board.board)
			@to = @player_2.ai_move_to(@board.board)
		end
	end

	def is_players_color?(from, to)
		return square(from).is_white != square(to).is_white ? true : false
	end

	def is_correct_color?(spot)
		if square(spot).is_white && !@turns.odd?
			return true
		elsif !square(spot).is_white && @turns.odd?
			return true
		else
			return false
		end
	end

	def is_valid_move?(from, to)
		if square(to) != " " && is_players_color?(from, to)
			return true
		elsif square(to) == " "
			return true
		else
			return false
		end
	end

	def start
		begin
			@board.display if @turns == 0
			until @check_mate
				proceed
			end
		rescue Interrupt
			rescue_interrupt
		end
	end

	def proceed
		puts "#{@turns.odd? ? "Black" : "White"} check!" if check?(@board.board)
		en_passant
		whose_turn if @is_human || (!@is_human && !@turns.odd?)
		play_piece
		@board.display
		turn
	end

	def play_piece
		check?(@board.board) ? when_check : when_not_check
		check_exit
		make_move
	end

	def make_move
		begin
			unless is_valid_move?(@from, @to)
				raise_invalid_move
			end
			if is_correct_color?(@from)
				set_en_passant_turn(@from, @to)
				play_move(@from, @to)
			else
				raise_invalid_move
			end
			give_ai_info unless @is_human
		rescue NoMethodError
			error_info
			start
		end
	end

	def give_ai_info
		whose_turn if !@is_human && @turns.odd?
		show_move if (!@is_huamn && @turns.odd?) && !@is_invalid
		@is_invalid = false
	end

	def play_move(from, to)
		to_cloned = to.clone
		unless is_getting_into_check?(from, to)
			if square(from).class == Pieces::Pawn 
				play_pawn(from, to)
			elsif square(from).is_legal_move?(convert_to_number(to_cloned))
				if square(from).class == Pieces::Knight
					play_knight(from, to)
				elsif square(from).class == Pieces::King || square(from).legal_list(convert_to_number(to_cloned)).all? { |n| square(n) == " " }
					play_rook(from, to)
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

	def play_knight(from, to)
		from[1] != to[1] ? place_piece(from, to) : raise_invalid_move
	end

	def play_rook(from, to)
		square(from).class == Pieces::Rook ? castle(from, to) : place_piece(from, to)
	end

	def play_pawn(from, to)
		from_cloned = from.clone
		to_cloned = to.clone
		if !square(from).is_legal_move?(convert_to_number(to_cloned))
			capture_pawn(from, to)
		elsif square(from).is_legal_move?(convert_to_number(to_cloned)) && square(to) == " "
			promote_pawn(from, to)
		else
			raise_invalid_move
		end
	end

	def promote_pawn(from, to)
		to_cloned = to.clone
		[1,2,3,4,5,6,7,8,57,58,59,60,61,62,63,64].include?(convert_to_number(to_cloned)) ? promote(from, to) : place_piece(from, to)
	end

	def capture_pawn(from, to)
		from_cloned = from.clone
		to_cloned = to.clone
		if [-7,-9,7,9].include?(convert_to_number(to_cloned) - convert_to_number(from_cloned)) && square(from).is_white != square(to).is_white
			[1,2,3,4,5,6,7,8,57,58,59,60,61,62,63,64].include?(convert_to_number(to_cloned)) ? promote(from, to) : place_piece(from, to)
		else
			raise_invalid_move
		end
	end

	def place_piece(from, to)
		to_cloned = to.clone
		if square(to).class != Pieces::King
			@board.board[to.join.to_sym] = square(from)
			square(to).moved = true
			square(to).times_moved += 1
			square(to).current_position = convert_to_number(to_cloned)
			@board.board[from.join.to_sym] = " "
		else
			raise_invalid_move
		end
	end

	def when_not_check
		@is_human ? human_play : ai_play
	end

	def is_getting_into_check?(from, to)
		board_cloned = @board.board.clone
		board_cloned[to.join.to_sym] = board_cloned[from.join.to_sym]
		board_cloned[from.join.to_sym] = " "
		if check?(board_cloned)
			if !@turns.odd? && board_cloned[to.join.to_sym].is_white
				return true
			elsif @turns.odd? && !board_cloned[to.join.to_sym].is_white
				return true
			else
				return false
			end
		else
			return false
		end
	end

	def check?(squares)
		squares.each do |key, value|
			if value != " "
				value.legal_move_list.each do |n|
					if (1..64).include?(value.current_position + n) && squares[convert_to_key(value.current_position + n).join.to_sym].class == Pieces::King
						if squares[convert_to_key(value.current_position + n).join.to_sym].is_white != value.is_white
							if value.class != Pieces::Knight
								if value.class == Pieces::Pawn
									return true
								elsif value.is_legal_move?(value.current_position + n) && value.legal_list(value.current_position + n).all? { |x| squares[convert_to_key(x).join.to_sym] == " " }
									return true
								end
							elsif value.is_legal_move?(value.current_position + n)
								return true
							end
						end
					end
				end
			end
		end
		return false
	end

	def when_check
		get_move_while_check
		while_check
		out_of_check
	end

	def while_check
		while still_check?(@from, @to)
			game_over if checkmate?
			get_move_while_check
		end
	end

	def get_move_while_check
		puts "\nYou are in a check position. Please enter your move to get out of it."
		print "From : "
		if @is_human
			@from = gets.chomp.chars
			@from[1] = @from[1].to_i
		else
			@from = @player_2.ai_move_from(@board.board)
		end
		print "To   : "
		if @is_human
			@to = gets.chomp.chars
			@to[1] = @to[1].to_i
		else
			@to = @player_2.ai_move_to(@board.board)
		end
	end	

	def still_check?(from, to)
		board_cloned = @board.board.clone
		board_cloned[to.join.to_sym] = board_cloned[from.join.to_sym]
		board_cloned[from.join.to_sym] = " "
		return true if check?(board_cloned)
	end

	def out_of_check
		if @turns.odd?
			@player_2.from = @from
			@player_2.to = @to
		else
			@player_1.from = @from
			@player_1.to = @to
		end
	end

	def checkmate?
		board_cloned = @board.board.clone
		board_cloned.each do |key, value|
			if value.class == Pieces::King
				if value.legal_move_list.all? { |m| board_cloned[convert_to_key(value.current_position + m).join.to_sym] != " "}
					value.legal_move_list.each do |m|
						if !board_cloned[convert_to_key(value.current_position + m).join.to_sym].nil? && board_cloned[convert_to_key(value.current_position + m).join.to_sym].is_white != value.is_white
							if still_check?(convert_to_key(value.current_position), convert_to_key(value.current_position + m))
								return true
							else
								return false
							end
						end
					end
				elsif value.legal_move_list.all? { |m| still_check?(convert_to_key(value.current_position), convert_to_key(value.current_position + m)) }
					return true
				else
					return false
				end
			end
		end
		return false
	end

	def game_over
		puts @turns.odd? ? "Checkmate! White Wins!" : "Checkmate! Black Wins!"
		exit
	end
end