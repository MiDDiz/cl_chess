module SpecialMoves

	def promote(from, to)
		promote_piece(from, to)
		move_after_promote(from, to)
	end

	def promote_piece(from, to)
		print "Pick a piece you would like to promote your pawn to: "
		@piece = gets.chomp.downcase.capitalize
		case @piece
		when "Pawn" then @piece = square(from).is_white ? Pieces::Pawn.new(true) : Pieces::Pawn.new
		when "Bishop" then @piece = square(from).is_white ? Pieces::Bishop.new(true) : Pieces::Bishop.new
		when "Rook" then @piece = square(from).is_white ? Pieces::Rook.new(true) : Pieces::Rook.new
		when "Knight" then @piece = square(from).is_white ? Pieces::Knight.new(true) : Pieces::Knight.new
		when "Queen" then @piece = square(from).is_white ? Pieces::Queen.new(true) : Pieces::Queen.new
		else
			promote_piece(from, to)
		end
	end

	def move_after_promote(from, to)
		to_cloned = to.clone
		@board.board[to.join.to_sym] = @piece
		square(to).current_position = convert_to_number(to_cloned)
		@board.board[from.join.to_sym] = " "
	end

	def castle (from, to)
		to_cloned = to.clone
		from_cloned = from.clone
		unless square(from).moved && check?(@board.board)
			if square(convert_to_number(to_cloned) + 1).class == Pieces::King && !square(convert_to_number(to_cloned) + 1).moved
				place_piece(from, to)
				place_piece(convert_to_key(convert_to_number(to_cloned) + 1), convert_to_key(convert_to_number(from_cloned) + 2)) if is_castling?
			elsif square(convert_to_number(to_cloned) - 1).class == Pieces::King && !square(convert_to_number(to_cloned) - 1).moved
				place_piece(from, to)
				place_piece(convert_to_key(convert_to_number(to_cloned) - 1), convert_to_key(convert_to_number(from_cloned) - 1)) if is_castling?
			else
				place_piece(from, to)
			end
		else
			place_piece(from, to)
		end
	end

	def is_castling?
		print "Would you like to castle?(y/n): "
		@is_human ? human_is_castling? : ai_is_castling?
	end

	def human_is_castling?
		response = gets.chomp.downcase
		case response
		when "y" then return true
		when "n" then return false
		end
	end

	def ai_is_castling?
		response = rand(2)
		case response
		when 1 then return true
		when 0 then return false
		end
	end

	def set_en_passant_turn(from, to)
		to_cloned = to.clone
		from_cloned = from.clone
		if (convert_to_number(to_cloned) - convert_to_number(from_cloned)).abs == 16 && (square(from).class == Pieces::Pawn && !square(from).moved)
			square(from).en_passant_valid = true
			@en_passant_turns = @turns
			return @en_passant_turns
		end
	end

	def en_passant
		@board.board.each do |key, value|
			if value.class == Pieces::Pawn && value.times_moved > 0
				if square(value.current_position - 1).class == Pieces::Pawn && @to.join < key.to_s
					if value.is_white != square(value.current_position - 1).is_white && square(value.current_position - 1).times_moved == 1
						next if is_en_passant_move?(key, value, [9,17,25,33,41,49,57], -1, [-9, 7])
					end
				elsif square(value.current_position + 1).class == Pieces::Pawn && @to.join > key.to_s
					if square(value.current_position + 1).times_moved == 1 && value.is_white != square(value.current_position + 1).is_white
						next if is_en_passant_move?(key, value, [8,16,24,32,40,48,56,64], 1, [-7, 9])
					end
				end
			end
		end
	end

	def is_en_passant_move?(key, value, list, num_1, num_list)
		num_2 = @turns.odd? ? num_list[0] : num_list[1]
		if square(value.current_position + num_1).en_passant_valid
			if @turns - @en_passant_turns == 1 && !list.include?(value.current_position)
				if is_en_passant?
					square(value.current_position + num_1).en_passant_valid = false
					@board.board[convert_to_key(value.current_position + num_1).join.to_sym] = " "
					@board.board[convert_to_key(value.current_position + num_2).join.to_sym] = value
					square(value.current_position + num_2).current_position = value.current_position + num_2
					@board.board[key] = " "
					@board.display
					turn
					return true
				else
					square(value.current_position + num_1).en_passant_valid = false
					return false
				end
			end
		end
	end

	def is_en_passant?
		whose_turn
		print "\nWould you like to do 'en passant'?: "
		@is_human ? is_en_passant_human? : is_en_passant_ai?
	end

	def is_en_passant_human?
		response = gets.chomp.downcase
		case response
		when "y" then return true
		when "n" then return false
		end
	end

	def is_en_passant_ai?
		response = rand(2)
		case response
		when 1 then return true
		when 0 then return false
		end
	end
end			