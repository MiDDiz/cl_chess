require_relative "board.rb"
require_relative "player.rb"

class Game
	attr_reader :board

	def initialize
		@player_1 = Player.new(true)
		@player_2 = Player.new
		@board = Board.new
		@turn = 0
	end

	def set_board
		keys = @board.board.keys
		keys1 = @player_1.pieces.keys
		keys2 = @player_1.pieces.keys

		keys[0..15].each do |key|
			@board.board[key] = @player_1.pieces[keys1.shift]
			@board.board[key].current_position = convert(key.to_s.chars)
		end

		keys[56..63].each do |key|
			@board.board[key] = @player_2.pieces[keys2.shift]
			@board.board[key].current_position = convert(key.to_s.chars)
		end

		keys[48..55].each do |key|
			@board.board[key] = @player_2.pieces[keys2.shift]
			@board.board[key].current_position = convert(key.to_s.chars)
		end
	end

	def turn
		puts @turn.odd? ? "It is Black's turn!" : "It is White's turn!"
		@turn += 1
	end

	def convert(move)
		case move[0]
		when "a" then move[0] = 0
		when "b" then move[0] = 1
		when "c" then move[0] = 2
		when "d" then move[0] = 3
		when "e" then move[0] = 4
		when "f" then move[0] = 5
		when "g" then move[0] = 6
		when "h" then move[0] = 7
		end
		move = (((move[1].to_i-1)*8) + move[0]) + 1
		return move
	end

	def convert_back(move)
		if [8,16,24,32,40,48,56,64].include?(move)
			move_0 = "h"
		else
			move_0 = ((move) % 8) - 1
		end
		move_1 = ((move) / 8) + 1
		case move_0
		when 0 then move_0 = "a"
		when 1 then move_0 = "b"
		when 2 then move_0 = "c"
		when 3 then move_0 = "d"
		when 4 then move_0 = "e"
		when 5 then move_0 = "f"
		when 6 then move_0 = "g"
		when 7 then move_0 = "h"
		end
		move = [] << move_0 << move_1
		return move
	end

	def play(from, to)
		check = to.clone
		if @board.board[from.join.to_sym].legal_move?(convert(to))
			if @board.board[from.join.to_sym].class == Pieces::Knight || @board.board[from.join.to_sym].legal_list(convert(to)).all?{ |n| @board.board[convert_back(n).join.to_sym] == " " }
				@board.board[check.join.to_sym] = @board.board[from.join.to_sym]
				@board.board[check.join.to_sym].current_position = convert(to)
				@board.board[from.join.to_sym] = " "
			end
		end
	end
end

game = Game.new
game.set_board
game.board.display
game.play(["a", 2], ["a", 4])
game.board.display
game.play(["a", 4], ["a", 5])
game.board.display
game.play(["a", 1], ["a", 4])
game.board.display
game.play(["a", 4], ["h", 4])
game.board.display
game.play(["b", 1], ["c", 3])
game.board.display
game.play(["d", 2], ["d", 4])
game.board.display
game.play(["c", 1], ["e", 3])
game.board.display