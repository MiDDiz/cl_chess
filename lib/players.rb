require_relative "pieces.rb"

module Players

	class Player
		include Pieces
		attr_accessor :name, :from, :to, :move
		attr_reader :pieces, :white

		def initialize(white=false)
			@name = "Comp"
			@white = white
			@pieces = [Rook.new(white), Knight.new(white), Bishop.new(white), Queen.new(white), King.new(white),
					   Bishop.new(white), Knight.new(white), Rook.new(white), Pawn.new(white), Pawn.new(white),
					   Pawn.new(white), Pawn.new(white), Pawn.new(white), Pawn.new(white), Pawn.new(white), Pawn.new(white)]
		end
	end

	class Comp < Player

		def get_move(output, input, board)
			comp_move_from(board)
			comp_move_to(board)
		end

		private

		def change_to_letter(number)
			number_to_letter_map = (0..7).zip(('a'..'h')).to_h
			return number_to_letter_map[number]
		end

		# Turns two randomly picked numbers to a valid board key symbol (e.g. :e4)
		def pick_move
			return (change_to_letter(rand(8)) + (rand(8) + 1).to_s).to_sym
		end

		# Picks a random valid piece
		def comp_move_from(board)
			@from = pick_move
			if board[@from] != " " && !board[@from].white
				return @from
			else
				comp_move_from(board)
			end
		end

		# Picks a random valid spot to play the piece
		def comp_move_to(board)
			@to = pick_move
			if board[@from].legal_move?(@from, @to)
				unless board[@from].class == Pawn || board[@from].class == Knight
					if board[@from].class == King || board[@from].legal_list(@from, @to).all? { |square| board[square] == " " }
						return @to
					else
						comp_move_to(board)
					end
				else
					return @to
				end
			else
				comp_move_to(board)
			end
		end
	end

	class Human < Player

		def get_name(output, input)
			output.puts "Enter your name:"
			@name = input.gets.chomp.downcase.capitalize
		end

		def get_move(output, input, board)
			output.puts "\nEnter your move (e.g. 'a2 a4'):"
			@move = input.gets.chomp
			if @move == "save"
				return @move
			elsif /^[a-h][1-8]\s+[a-h][1-8]$/ =~ @move
				@from = @move.split[0].to_sym
				@to = @move.split[1].to_sym
			else
				get_move(output, input, board)
			end
		end
	end
end