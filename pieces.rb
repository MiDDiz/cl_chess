module Pieces

	class Pawn
		attr_reader :white_sign, :black_sign

		def initialize
			@white_sign = "\u265F"
			@black_sign = "\u2659"
			@current_position = nil
		end

		def set_current_position(position)
			@current_position = position
		end

		def legal_move?(move)
			if [8,9,10,11,12,13,14,15].include?(@current_position)
				return true if [8, 16].include?(move - @current_position) && (0..7).include?(move)
			end
			return true if move - @current_position == 8 && move - @current_position >= 0
		end
	end

	class Rook
		attr_reader :white_sign, :black_sign

		def initialize
			@white_sign = "\u265C"
			@black_sign = "\u2656"
			@current_position = nil
		end

		def set_current_position(position)
			@current_position = position
		end

		def legal_move?(move)
			return true if [8,16,24,32,40,48,56].include?(move - @current_position) && (0..7).include?(move)
			return true if [8,16,24,32,40,48,56].include?(@current_position - move) && (0..7).include?(move)
		end
	end

	class Knight
		attr_reader :white_sign, :black_sign

		def initialize
			@white_sign = "\u265E"
			@black_sign = "\u2658"
			@current_position = nil
		end

		def set_current_position(position)
			@current_position = position
		end

		def legal_move?(move)
			return true if [6,10,15,17].include?(move - @current_position) && (0..7).include?(move)
			return true if [6,10,15,17].include?(@current_position - move) && (0..7).include?(move)
		end
	end

	class Bishop
		attr_reader :white_sign, :black_sign

		def initialize
			@white_sign = "\u265D"
			@black_sign = "\u2657"
			@current_position = nil
		end

		def set_current_position(position)
			@current_position = position
		end

		def legal_move?(move)
			return true if [9,18,27,36,45,53,62].include?(move - @current_position) && (0..7).include?(move)
			return true if [9,18,27,36,45,53,62].include?(@current_position - move) && (0..7).include?(move)
		end
	end

	class King
		attr_reader :white_sign, :black_sign

		def initialize
			@white_sign = "\u265A"
			@black_sign = "\u2654"
			@current_position = nil
		end

		def set_current_position(position)
			@current_position = position
		end

		def legal_move?(move)
			if move[0] - @current_position[0] == 1 && move[1] == @current_position[1]
				return true if [7,8,9].include?(move - @current_position) && (0..7).include?(move)
				return true if [7,8,9].include?(@current_position - move) && (0..7).include?(move)
			end
		end
	end

	class Queen
		attr_reader :white_sign, :black_sign

		def initialize
			@white_sign = "\u265B"
			@black_sign = "\u2655"
			@current_position = nil
		end

		def set_current_position(position)
			@current_position = position
		end

		def legal_move?(move)
			if move[0] - @current_position[0] == 1 && move[1] == @current_position[1]
				return true if [8,16,24,32,40,48,56,9,18,27,36,45,53,62].include?(move - @current_position) && (0..7).include?(move)
				return true if [8,16,24,32,40,48,56,9,18,27,36,45,53,62].include?(@current_position - move) && (0..7).include?(move)
			end
		end
	end
end
