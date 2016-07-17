module Pieces

	class Piece
		attr_accessor :current_position
		attr_reader :sign
	end

	class Pawn < Piece

		def initialize(white=false)
			@sign = white ? "\u265F" : "\u2659"
			@current_position = nil
		end

		def legal_move?(move)
			if [8,9,10,11,12,13,14,15].include?(@current_position)
				return true if [8, 16].include?(move - @current_position) && (0..63).include?(move)
			elsif move - @current_position == 8 && move - @current_position >= 0
				return true
			end
			return false
		end

		def legal_list(move)
			list = []
			check = @current_position
			list << check + 8
			return list
		end
	end

	class Rook < Piece

		def initialize(white=false)
			@sign = white ? "\u265C" : "\u2656"
			@current_position = nil
		end

		def legal_move?(move)
			return true if [1,2,3,4,5,6,7,8,16,24,32,40,48,56].include?(move - @current_position) && (0..63).include?(move)
			return true if [1,2,3,4,5,6,7,8,16,24,32,40,48,56].include?(@current_position - move) && (0..63).include?(move)
			return false
		end

		def legal_list(move)
			list = []
			check = @current_position + 1
			if (move - @current_position) < 8
				until check == move+1
					list << check
					check += 1
				end
			else
				check = @current_position
				until check == move
					check += 8
					list << check
				end
			end
			return list
		end
	end

	class Knight < Piece

		def initialize(white=false)
			@sign = white ? "\u265E" : "\u2658"
			@current_position = nil
		end

		def legal_move?(move)
			return true if [6,10,15,17].include?(move - @current_position) && (0..63).include?(move)
			return true if [6,10,15,17].include?(@current_position - move) && (0..63).include?(move)
			return false
		end
	end

	class Bishop < Piece

		def initialize(white=false)
			@sign = white ? "\u265D" : "\u2657"
			@current_position = nil
		end

		def legal_move?(move)
			return true if [7,9,14,18,21,27,28,36,35,45,42,53,49,56,62].include?(move - @current_position) && (0..63).include?(move)
			return true if [7,9,14,18,21,27,28,36,35,45,42,53,49,56,62].include?(@current_position - move) && (0..63).include?(move)
			return false
		end

		def legal_list(move)
			list = []
			if move - @current_position > 0
				if [7,14,21,28,35,42,49,56].include?(move - @current_position)
					check = @current_position + 7
					until check > move
						list << check
						check += 7
					end
				else
					check = @current_position + 9
					until check > move
						list << check
						check += 9
					end
				end
			else
				if [7,14,21,28,35,42,49,56].include?(@current_position - move)
					check = @current_position - 7
					until move > check
						list << check
						check -= 7
					end
				else
					check = @current_position - 9
					until move > check
						list << check
						check -= 9
					end
				end
			end
			return list
		end
	end

	class King < Piece

		def initialize(white=false)
			@sign = white ? "\u265A" : "\u2654"
			@current_position = nil
		end

		def legal_move?(move)
			return true if [7,8,9].include?(move - @current_position) && (0..63).include?(move)
			return true if [7,8,9].include?(@current_position - move) && (0..63).include?(move)
			return false
		end

		def legal_list(move)
			check = @current_position
			list = []
		end
	end

	class Queen < Piece

		def initialize(white=false)
			@sign = white ? "\u265B" : "\u2655"
			@current_position = nil
		end

		def legal_move?(move)
			return true if [8,16,24,32,40,48,56,9,18,27,36,45,53,62].include?(move - @current_position) && (0..63).include?(move)
			return true if [8,16,24,32,40,48,56,9,18,27,36,45,53,62].include?(@current_position - move) && (0..63).include?(move)
			return false
		end

		def legal_list(move)
			check = @current_position
			list = []
		end
	end
end

rook = Pieces::Rook.new
