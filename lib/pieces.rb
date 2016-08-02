module Pieces

	class Piece
		attr_accessor :current_position, :moved, :times_moved
		attr_reader :sign, :white, :legal_move_list

		def initialize(white=false)
			@current_position = nil
			@white = white
			@moved = false
			@times_moved = 0
		end
	end

	class Pawn < Piece
		attr_accessor :en_passant_valid

		def initialize(white=false)
			super
			@sign = white ? "\u265F" : "\u2659"
			@legal_move_list = [7,9]
			@en_passant_valid = false
		end

		def legal_move?(move)
			if !@moved
				if @white
					return true if [8, 16].include?(move - @current_position) && (1..64).include?(move)
				else
					return true if [8, 16].include?(@current_position - move) && (1..64).include?(move)
				end
			else 
				if @white
					return true if move - @current_position == 8 && move - @current_position >= 0
				else
					return true if @current_position - move == 8 && @current_position - move >= 0
				end
			end
			return false
		end
	end

	class Rook < Piece

		def initialize(white=false)
			super
			@sign = white ? "\u265C" : "\u2656"
			@legal_move_list = [-1,-2,-3,-4,-5,-6,-7,-8,-16,-24,-32,-40,-48,-56,1,2,3,4,5,6,7,8,16,24,32,40,48,56]
		end

		def legal_move?(move)
			if (move - @current_position) > 0 && (move - @current_position) < 8
				delimiter = 8
				[1,2,3,4,5,6,7].each do |n|
					[(1..7),(9..16),(17..23),(25..31),(33..39),(41..47),(49..55),(57..63)].each do |range|
						if range.include?(@current_position) && @current_position + n <= delimiter
							return true
						end
						delimiter += 8
					end
				end
				return false
			elsif (move - @current_position) < 0 && (move - @current_position) > -8
				delimiter = 57
				[1,2,3,4,5,6,7].each do |n|
					[(58..64),(49..56),(41..48),(33..40),(25..32),(17..24),(9..16),(1..7)].each do |range|
						if range.include?(@current_position) && @current_position + n >= delimiter
							return true
						end
						delimiter -= 8
					end
				end
				return false
			else
				return true if [8,16,24,32,40,48,56].include?(move - @current_position) && (1..64).include?(move)
				return true if [8,16,24,32,40,48,56].include?(@current_position - move) && (1..64).include?(move)
				return false
			end
		end

		def legal_list(move)
			list = []
			check = @current_position
			if (move - @current_position) > 0 && (move - @current_position) < 8
				until check == move-1
					check += 1
					list << check
				end
			elsif (move - @current_position) < 0 && (move - @current_position) > -8
				until check == move+1
					check -= 1
					list << check
				end
			elsif (move - @current_position) >= 8
				until check == move-8
					check += 8
					list << check
				end
			elsif (move - @current_position) <= -8
				until check == move+8
					check -= 8
					list << check
				end
			end
			return list
		end
	end

	class Knight < Piece

		def initialize(white=false)
			super
			@sign = white ? "\u265E" : "\u2658"
			@legal_move_list = [-6,-10,-15,-17,6,10,15,17]
		end

		def legal_move?(move)
			return true if [6,10,15,17].include?(move - @current_position) && (0..63).include?(move)
			return true if [6,10,15,17].include?(@current_position - move) && (0..63).include?(move)
			return false
		end
	end

	class Bishop < Piece

		def initialize(white=false)
			super
			@sign = white ? "\u265D" : "\u2657"
			@legal_move_list = [-7,-9,-14,-18,-21,-27,-28,-36,-35,-45,-42,-53,-49,-56,-62,7,9,14,18,21,27,28,36,35,45,42,53,49,56,62]
		end

		def legal_move?(move)
			return true if [7,9,14,18,21,27,28,36,35,45,42,53,49,56,62].include?(move - @current_position) && (1..64).include?(move)
			return true if [7,9,14,18,21,27,28,36,35,45,42,53,49,56,62].include?(@current_position - move) && (1..64).include?(move)
			return false
		end

		def legal_list(move)
			list = []
			check = @current_position
			puts move - @current_position
			if move - @current_position > 0
				if [7,14,21,28,35,42,49,56].include?(move - @current_position)
					until check == move-7
						check += 7
						list << check
					end
				else
					until check == move-9
						check += 9
						list << check
					end
				end
			else
				if [7,14,21,28,35,42,49,56].include?(@current_position - move)
					until (move+7).abs == check
						check -= 7
						list << check
					end
				else
					until (move+9).abs == check
						check -= 9
						list << check
					end
				end
			end
			return list
		end
	end

	class King < Piece

		def initialize(white=false)
			super
			@sign = white ? "\u265A" : "\u2654"
			@legal_move_list = [-1,-7,-8,-9,1,7,8,9]
		end

		def legal_move?(move)
			return true if [1,7,8,9].include?(move - @current_position) && (0..63).include?(move)
			return true if [1,7,8,9].include?(@current_position - move) && (0..63).include?(move)
			return false
		end
	end

	class Queen < Piece

		def initialize(white=false)
			super
			@sign = white ? "\u265B" : "\u2655"
			@legal_move_list = [-1,-2,-3,-4,-5,-6,-7,-8,-9,-14,-16,-18,-21,-24,-27,-28,-32,-35,-36,-40,-42,-45,-48,-49,-54,-56,-62,-63,-64,1,2,3,4,5,6,7,8,9,14,16,18,21,24,27,28,32,35,36,40,42,45,48,49,54,56,62,63,64]
		end

		def legal_move?(move)
			if (move - @current_position) > 0 && (move - @current_position) < 8
				limiter = 8
				[1,2,3,4,5,6,7].each do |n|
					[(1..8),(9..16),(17..23),(25..31),(33..39),(41..47),(49..55),(57..63)].each do |range|
						if range.include?(@current_position) && @current_position + n <= limiter
							return true
						end
						limiter += 8
					end
				end
				return false
			elsif (move - @current_position) < 0 && (move - @current_position) > -8
				limiter = 57
				[1,2,3,4,5,6,7].each do |n|
					[(57..64),(49..56),(41..48),(33..40),(25..32),(17..24),(9..16),(1..7)].each do |range|
						if range.include?(@current_position) && @current_position + n >= limiter
							return true
						end
						limiter -= 8
					end
				end
				return false
			else
				return true if [7,8,9,14,16,18,21,24,27,28,32,35,36,40,42,45,48,49,54,56,62,63,64].include?(move - @current_position) && (1..64).include?(move)
				return true if [7,8,9,14,16,18,21,24,27,28,32,35,36,40,42,45,48,49,54,56,62,63,64].include?(@current_position - move) && (1..64).include?(move)
				return false
			end
		end

		def legal_list(move)
			list = []
			check = @current_position
			if [1,2,3,4,5,6].include?(move - @current_position)
				until check == move-1
					check += 1
					list << check
				end
			elsif [1,2,3,4,5,6].include?(@current_position - move)
				until check == move+1
					check -= 1
					list << check
				end
			elsif [8,16,24,32,40,48,56,64].include?(move - @current_position)
				until check == move-8
					check += 8
					list << check
				end
			elsif [8,16,24,32,40,48,56,64].include?(@current_position - move)
				until check == move+8
					check -= 8
					list << check
				end
			elsif [7,14,21,28,35,42,49,56,63].include?(move - @current_position)
				until check == move-7
					check += 7
					list << check
				end
			elsif [7,14,21,28,35,42,49,56,63].include?(@current_position - move)
				until check == move+7
					check -= 7
					list << check
				end
			elsif [9,18,27,36,45,54,63].include?(move - @current_position)
				until check == move-9
					check += 9
					list << check
				end
			elsif [9,18,27,36,45,54,63].include?(@current_position - move)
				until check == move+9
					check -= 9
					list << check
				end
			end
			return list
		end
	end
end