require_relative "pieces.rb"
require_relative "technical.rb"

class Player
	include Pieces
	attr_accessor :name, :from, :to
	attr_reader :pieces, :white

	def initialize(white=false)
		@name = "Comp"
		@white = white
		@pieces = { rook_1: Rook.new(white),
					knight_1: Knight.new(white),
					bishop_1: Bishop.new(white),
					queen: Queen.new(white),
					king: King.new(white),
					bishop_2: Bishop.new(white),
					knight_2: Knight.new(white),
					rook_2: Rook.new(white),
					pawn_1: Pawn.new(white),
				    pawn_2: Pawn.new(white),
				    pawn_3: Pawn.new(white),
				    pawn_4: Pawn.new(white),
				    pawn_5: Pawn.new(white),
				    pawn_6: Pawn.new(white),
				    pawn_7: Pawn.new(white),
				    pawn_8: Pawn.new(white) }
	end
end

class AI < Player
	include Technical

	def pick_move
		number = (rand(8) + 1).to_s
		letter = change(rand(8))
		@move = (letter + number).chars
		@move[1] = @move[1].to_i
		return @move
	end

	def ai_from(board)
		@from = pick_move
		if board[@from.join.to_sym] != " " && !board[@from.join.to_sym].white
			return @from
		else
			ai_from(board)
		end
	end

	def ai_to(board)
		@to = pick_move
		to_cloned = @to.clone
		if board[@from.join.to_sym].legal_move?(convert(to_cloned))
			unless board[@from.join.to_sym].class == Pawn || board[@from.join.to_sym].class == Knight
				if board[@from.join.to_sym].class == King || board[@from.join.to_sym].legal_list(convert(to_cloned)).all? { |n| board[convert_back(n).join.to_sym] == " " }
					return @to
				else
					ai_to(board)
				end
			else
				return @to
			end
		else
			ai_to(board)
		end
	end
end

class Human < Player

	def get_name
		print "Enter Player's name: "
		@name = gets.chomp.downcase.capitalize
	end

	def make_move
		puts "\nEnter your move."
		print "From : "
		@from = gets.chomp.chars
		print "To   : "
		@to = gets.chomp.chars
		unless (("a".."h").include?(@from[0]) || ("a".."h").include?(@to[0])) || ((1..8).include?(@from[1]) || (1..8).include?(@to[1]))
			rescue_make_move
		else
			@from[1] = @from[1].to_i
			@to[1] = @to[1].to_i
		end
	end

	def rescue_make_move
		puts "\n======================================================================"
		puts "!!! INVALID INPUT !!!".center(65)
		puts "Check your input:"
		puts "  * The format of your input should be as follows: a4, b1, d8, etc..."
		puts "  * There might not be any piece on the spot you've specified."
		puts "======================================================================"
		make_move
	end
end