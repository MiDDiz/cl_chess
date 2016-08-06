module SpecialMoves

	def promote(from, to)
		promote_piece(from, to)
		promote_move(from, to)
	end

	def promote_piece(from, to)
		print "Pick a piece you would like to promote your pawn to: "
		@piece = gets.chomp.downcase.capitalize
		case @piece
		when "Pawn" then @piece = @board.board[from.join.to_sym].white ? Pieces::Pawn.new(true) : Pieces::Pawn.new
		when "Bishop" then @piece = @board.board[from.join.to_sym].white ? Pieces::Bishop.new(true) : Pieces::Bishop.new
		when "Rook" then @piece = @board.board[from.join.to_sym].white ? Pieces::Rook.new(true) : Pieces::Rook.new
		when "Knight" then @piece = @board.board[from.join.to_sym].white ? Pieces::Knight.new(true) : Pieces::Knight.new
		when "Queen" then @piece = @board.board[from.join.to_sym].white ? Pieces::Queen.new(true) : Pieces::Queen.new
		else
			promote_piece(from, to)
		end
	end

	def promote_move(from, to)
		to_cloned = to.clone
		@board.board[to.join.to_sym] = @piece
		@board.board[to.join.to_sym].current_position = convert(to_cloned)
		@board.board[from.join.to_sym] = " "
	end

	def castle (from, to)
		to_cloned = to.clone
		from_cloned = from.clone
		unless @board.board[from.join.to_sym].moved && check?(@board.board)
			if @board.board[convert_back(convert(to_cloned) + 1).join.to_sym].class == Pieces::King && !@board.board[convert_back(convert(to_cloned) + 1).join.to_sym].moved
				place_piece(from, to)
				place_piece(convert_back(convert(to_cloned) + 1), convert_back(convert(from_cloned) + 2)) if castling?
			elsif @board.board[convert_back(convert(to_cloned) - 1).join.to_sym].class == Pieces::King && !@board.board[convert_back(convert(to_cloned) - 1).join.to_sym].moved
				place_piece(from, to)
				place_piece(convert_back(convert(to_cloned) - 1), convert_back(convert(from_cloned) - 1)) if castling?
			else
				place_piece(from, to)
			end
		else
			place_piece(from, to)
		end
	end

	def castling?
		print "Would you like to castle?(y/n): "
		if @response
			castling_human
		else
			castling_ai
		end
	end

	def castling_human
		response = gets.chomp.downcase
		case response
		when "y" then response = true
		when "n" then response = false
		end
		return response
	end

	def castling_ai
		response = rand(2)
		case response
		when 1 then response = true
		when 0 then response = false
		end
		return response
	end

	def en_passant_turn(from, to)
		to_cloned = to.clone
		from_cloned = from.clone
		if (convert(to_cloned) - convert(from_cloned)).abs == 16 && (@board.board[from.join.to_sym].class == Pieces::Pawn && !@board.board[from.join.to_sym].moved)
			@board.board[from.join.to_sym].en_passant_valid = true
			@en_passant_turns = @turns
			return @en_passant_turns
		end
	end

	def en_passant
		@board.board.each do |key, value|
			if value.class == Pieces::Pawn && value.times_moved > 0
				if @board.board[convert_back(value.current_position - 1).join.to_sym].class == Pieces::Pawn
					if value.white != @board.board[convert_back(value.current_position - 1).join.to_sym].white && @board.board[convert_back(value.current_position - 1).join.to_sym].times_moved == 1
						next if en_passant_move(key, value, [9,17,25,33,41,49,57], -1, [-9, 7])
					end
				elsif @board.board[convert_back(value.current_position + 1).join.to_sym].class == Pieces::Pawn
					if @board.board[convert_back(value.current_position + 1).join.to_sym].times_moved == 1 && value.white != @board.board[convert_back(value.current_position + 1).join.to_sym].white
						next if en_passant_move(key, value, [8,16,24,32,40,48,56,64], 1, [-7, 9])
					end
				end
			end
		end
	end

	def en_passant_move(key, value, list, num_1, num_list)
		num_2 = @turns.odd? ? num_list[0] : num_list[1]
		if @board.board[convert_back(value.current_position + num_1).join.to_sym].en_passant_valid
			if @turns - @en_passant_turns == 1 && !list.include?(value.current_position)
				if en_passant?
					@board.board[convert_back(value.current_position + num_1).join.to_sym].en_passant_valid = false
					@board.board[convert_back(value.current_position + num_1).join.to_sym] = " "
					@board.board[convert_back(value.current_position + num_2).join.to_sym] = value
					@board.board[convert_back(value.current_position + num_2).join.to_sym].current_position = value.current_position + num_2
					@board.board[key] = " "
					@board.display
					turn
					return true
				else
					@board.board[convert_back(value.current_position + num_1).join.to_sym].en_passant_valid = false
					return false
				end
			end
		end
	end

	def en_passant?
		whose_turn
		print "\nWould you like to do 'en passant'?: "
		if @response
			en_passant_human
		else
			en_passant_ai
		end
	end

	def en_passant_human
		response = gets.chomp.downcase
		case response
		when "y" then response = true
		when "n" then response = false
		end
		return response
	end

	def en_passant_ai
		response = rand(2)
		case response
		when 1 then response = true
		when 0 then response = false
		end
		return response
	end
end			