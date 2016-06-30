module Pieces

	class Pawn
		attr_reader :white_sign, :black_sign

		def initialize
			@white_sign = "\u265F"
			@black_sign = "\u2659"
		end
	end

	class Rook
		attr_reader :white_sign, :black_sign

		def initialize
			@white_sign = "\u265C"
			@black_sign = "\u2656"
		end
	end

	class Knight
		attr_reader :white_sign, :black_sign

		def initialize
			@white_sign = "\u265E"
			@black_sign = "\u2658"
		end
	end

	class Bishop
		attr_reader :white_sign, :black_sign

		def initialize
			@white_sign = "\u265D"
			@black_sign = "\u2657"
		end
	end

	class King
		attr_reader :white_sign, :black_sign

		def initialize
			@white_sign = "\u265A"
			@black_sign = "\u2654"
		end
	end

	class Queen
		attr_reader :white_sign, :black_sign

		def initialize
			@white_sign = "\u265B"
			@black_sign = "\u2655"
		end
	end
end
