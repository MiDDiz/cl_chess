module SpecialMoves

	def promote(from, to)
		to_cloned = to.clone
		print "Pick a piece you would like to promote your pawn to: "
		piece = gets.chomp.downcase.capitalize
		case piece
		when "Pawn" then piece = @board.board[from.join.to_sym].white ? Pieces::Pawn.new(true) : Pieces::Pawn.new
		when "Bishop" then piece = @board.board[from.join.to_sym].white ? Pieces::Bishop.new(true) : Pieces::Bishop.new
		when "Rook" then piece = @board.board[from.join.to_sym].white ? Pieces::Rook.new(true) : Pieces::Rook.new
		when "Knight" then piece = @board.board[from.join.to_sym].white ? Pieces::Knight.new(true) : Pieces::Knight.new
		when "Queen" then piece = @board.board[from.join.to_sym].white ? Pieces::Queen.new(true) : Pieces::Queen.new
		end
		@board.board[to.join.to_sym] = piece
		@board.board[from.join.to_sym] = " "
	end

	def castle (from, to)
		to_cloned = to.clone
		from_cloned = from.clone
		unless @board.board[from.join.to_sym].moved
			if @board.board[convert_back(convert(to_cloned) + 1).join.to_sym].class == Pieces::King && !@board.board[convert_back(convert(to_cloned) + 1).join.to_sym].moved
				place_piece(from, to)
				place_piece(convert_back(convert(to_cloned) + 1), convert_back(convert(from_cloned) + 1)) if castling?
			elsif @board.board[convert_back(convert(to_cloned) - 1).join.to_sym].class == Pieces::King && !@board.board[convert_back(convert(to_cloned) - 1).join.to_sym].moved
				place_piece(from, to)
				place_piece(convert_back(convert(to_cloned) - 1), convert_back(convert(from_cloned) - 2)) if castling?
			else
				take_out(from, to) if @board.board[to.join.to_sym] != " "
				place_piece(from, to)
			end
		else
			take_out(from, to) if @board.board[to.join.to_sym] != " "
			place_piece(from, to)
		end
	end

	def castling?
		print "Would you like to castle?(y/n): "
		respond = gets.chomp.downcase
		case respond
		when "y" then respond = true
		when "n" then respond = false
		end
		return respond
	end

	def en_passant(from, to)
		@board.board.each do |key, value|
			if value.class == Pieces::Pawn && value.times_moved > 0
				if @board.board[convert_back(value.current_position - 1).join.to_sym].class == Pieces::Pawn
					if value.white != @board.board[convert_back(value.current_position - 1).join.to_sym].white && @board.board[convert_back(value.current_position - 1).join.to_sym].times_moved == 1
						if en_passant?
							@board.board[convert_back(value.current_position - 1).join.to_sym].white ? @taken_black << @board.board[to.join.to_sym] : @taken_white << @board.board[to.join.to_sym]
							@board.board[convert_back(value.current_position - 1).join.to_sym] = " "
							value.white ? @board.board[convert_back(value.current_position + 7).join.to_sym] = value : @board.board[convert_back(value.current_position - 9).join.to_sym] = value
							@board.board[key] = " "
							@board.display
							turn
							next
						end
					end
				elsif @board.board[convert_back(value.current_position + 1).join.to_sym].class == Pieces::Pawn
					if @board.board[convert_back(value.current_position + 1).join.to_sym].times_moved == 1 && value.white != @board.board[convert_back(value.current_position + 1).join.to_sym].white
						if en_passant?
							@board.board[convert_back(value.current_position + 1).join.to_sym].white ? @taken_black << @board.board[to.join.to_sym] : @taken_white << @board.board[to.join.to_sym]
							@board.board[convert_back(value.current_position + 1).join.to_sym] = " "
							value.white ? @board.board[convert_back(value.current_position + 9).join.to_sym] = value : @board.board[convert_back(value.current_position - 7).join.to_sym] = value
							@board.board[key] = " "
							@board.display
							turn
							next
						end
					end
				end
			end
		end
	end

	def en_passant?
		print "Would you like to do 'en passant'?: "
		respond = gets.chomp.downcase
		case respond
		when "y" then respond = true
		when "n" then respond = false
		end
		return respond
	end

	def check_enpassant(from, to)
		unless from.nil? && to.nil?
			from_cloned = from.clone
			to_cloned = to.clone
			if @turns.odd?
				en_passant(from, to) if (convert(to_cloned) - convert(from_cloned) == 16) && @board.board[to.join.to_sym].class == Pieces::Pawn
			else
				en_passant(from, to) if (convert(to_cloned) - convert(from_cloned) == -16) && @board.board[to.join.to_sym].class == Pieces::Pawn
			end
		end
	end
end			