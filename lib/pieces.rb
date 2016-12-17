module Pieces

	class Piece
		attr_accessor :moved
		attr_reader :sign, :white

		def initialize(white=false)
			@white = white
			@moved = false			# Necessary for both castling and enpassant	
		end

		private

		# _legal? methods check the characters of the board key symbols to determine the validity of a move.
		def str_legal?(from, to)
			return true if from[0] == to[0] && from[1] != to[1] # The squares on the same column share the same letter
			return true if from[0] != to[0] && from[1] == to[1] # The squares on the same row share the same number
		end

		def dia_legal?(from, to)
			# The difference of the letters and that of the numbers of two diagonally aligned squares are the same.
			return true if (from[0].ord - to[0].ord).abs == (from[1].ord - to[1].ord).abs
		end

		# _line methods increment or decrement the key symbol characters to adjust the position of the piece played 
		# according to the destination. Changing the letter moves the piece horizontally, changing the number moves
		# piece vertically and changing both at the same time moves the piece diagonally.
		def hor_line(from, to)
			if from != to
				from = from.to_s.chars 					# Makes an array of the key symbol characters to be modified
				if from[0] < to[0]						# Goes to right (the key letter of the piece played is smaller)
					from[0] = from[0].next				# Increments the ascii value of the letter
				elsif from[0] > to[0]					# Goes to left (the key letter of the piece played is bigger)
					from[0] = (from[0].ord.pred).chr 	# Decrements the ascii value of the letter
				end
				return from.join.to_sym
			end
		end

		def ver_line(from, to)
			if from != to
				from = from.to_s.chars 					# Makes an array of the key symbol characters to be modified
				if from[1] < to[1]						# Goes upwards (the key number of the piece played is smaller)
					from[1] = (from[1].to_i + 1).to_s 	# Increments the value of the number
				elsif from[1] > to[1]					# Goes downwards (the key number of the piece played is bigger)
					from[1] = (from[1].to_i - 1).to_s 	# Decrements the value of the number
				end
				return from.join.to_sym
			end
		end

		def dia_line(from, to)
			return ver_line(hor_line(from, to), to) if from != to # Changes both the letter and the number at the same time
		end
	end

	class Pawn < Piece
		attr_accessor :en_passant_valid		# Necessary for marking the piece for enpassant move

		def initialize(white=false)
			super
			@sign = white ? "\u265F" : "\u2659"
			@en_passant_valid = false
		end

		# Checks the validity by checking the differences of the letter and number values of the key symbols.
		# Difference of 1 for numbers (if it's white's turn, else the difference should be -1) and that of 0
		# for letters is valid. The moved flag should be false for the second square jump. 
		def legal_move?(from, to)
			if from[0].ord - to[0].ord == 0 && from[1].ord - to[1].ord == 1 && !@white
				return true
			elsif from[0].ord - to[0].ord == 0 && from[1].ord - to[1].ord == -1 && @white
				return true
			elsif from[0].ord - to[0].ord == 0 && (from[1].ord - to[1].ord).abs == 2 && !moved
				return true
			end
		end
	end

	class Rook < Piece

		def initialize(white=false)
			super
			@sign = white ? "\u265C" : "\u2656"
		end

		def legal_move?(from, to)
			return str_legal?(from, to)
		end

		# Return a list of all the squares from the initial square of the move to and not including the destination
		# square to check if the squares are occupied or not.
		def legal_list(from, to)
			list = []
			until from == to
				if from[1] < to[1] || from[1] > to[1]		# If the move is upwards or downwards (see ver_line for more info)
					from = ver_line(from, to)
				elsif from[0] < to[0] || from[0] > to[0]	# If the move is to the right or left (see hor_line for more info)
					from = hor_line(from, to)
				end
				list << from
			end
			list.pop
			return list
		end
	end

	class Knight < Piece

		def initialize(white=false)
			super
			@sign = white ? "\u265E" : "\u2658"
		end

		# Checks the validity by checking the differences of the letter and number values of the key symbols.
		# An absolute difference of 1 for numbers and that of 2 for letter and vice verca ared valid 
		# for knight's L shaped move. An absolute difference because Knight can move back and forth.
		def legal_move?(from, to)
			if (from[0].ord - to[0].ord).abs == 1 && (from[1].ord - to[1].ord).abs == 2		# Vertical L
				return true
			elsif (from[0].ord - to[0].ord).abs == 2 && (from[1].ord - to[1].ord).abs == 1	# Horizontal L
				return true
			end
		end
	end

	class Bishop < Piece

		def initialize(white=false)
			super
			@sign = white ? "\u265D" : "\u2657"
		end

		def legal_move?(from, to)
			return dia_legal?(from, to)
		end

		# Return a list of all the squares from the initial square of the move to and not including the destination
		# square to check if the squares are occupied or not.
		def legal_list(from, to)
			list = []
			until from == to
				from = dia_line(from, to)
				list << from
			end
			list.pop
			return list
		end
	end

	class King < Piece

		def initialize(white=false)
			super
			@sign = white ? "\u265A" : "\u2654"
		end

		# Checks the validity by checking the differences of the letter and number values of the key symbols.
		# An absolute difference of 1 for numbers and that of 0 for letters is valid and vice versa, and so is the
		# difference of 1 for both numbers and letter. An absolute difference because King can go back and forth. 
		def legal_move?(from, to)
			if from[0].ord - to[0].ord == 0 && (from[1].ord - to[1].ord).abs == 1				# Vertical move
				return true
			elsif (from[0].ord - to[0].ord).abs == 1 && from[1].ord - to[1].ord == 0			# Horizantal move
				return true
			elsif (from[0].ord - to[0].ord).abs == 1 && (from[1].ord - to[1].ord).abs == 1		# Diagonal move
				return true
			end
		end
	end

	class Queen < Piece

		def initialize(white=false)
			super
			@sign = white ? "\u265B" : "\u2655"
		end

		def legal_move?(from, to)
			return dia_legal?(from, to) unless str_legal?(from, to)
			return str_legal?(from, to) unless dia_legal?(from, to)
		end

		# Return a list of all the squares from the initial square of the move to and not including the destination
		# square to check if the squares are occupied or not.
		def legal_list(from, to)
			list = []
			until from == to
				if dia_legal?(from, to)						# If the move is diagonal (see dia_line for more info)
					from = dia_line(from, to)
				elsif from[1] < to[1] || from[1] > to[1]	# If the move is upwards or downwards (see ver_line for more info)
					from = ver_line(from, to)
				elsif from[0] < to[0] || from[0] > to[0]	# If the move is to left or to right (see hor_line for more info)
					from = hor_line(from, to)
				end
				list << from
			end
			list.pop
			return list
		end
	end
end