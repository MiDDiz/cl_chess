require_relative "board.rb"
require_relative "player.rb"
require_relative "special_moves.rb"
require_relative "technical.rb"

class Game
	include SpecialMoves
	include Technical
	attr_reader :board, :taken_black, :taken_white

	def initialize
		@player_1 = Player.new(true)
		@player_2 = Player.new
		@board = Board.new
		@turns = 0
		@taken_black = []
		@taken_white = []
		@over = false
		options
		new_or_saved
	end

	def welcome
		puts "======================================================="
		puts "Welcome to the command-line chess! You know the rules!"
		puts "So hop on and have fun!".center(50)
		puts "======================================================="
	end

	def start
		system("clear")
		sleep 1
		welcome
		@player_1.get_name
		@player_2.get_name
		system("clear")
		sleep 1
		set_board
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
		@turns += 1
	end

	def whose_turn
		puts "\n#{@player_1.name} has the white pieces. #{@player_2.name} has the black pieces." if @turns.zero?
		puts @turns.odd? ? "\nIt is Black's turn!" : "\nIt is White's turn!"
	end

	def place_piece(from, to)
		to_cloned = to.clone
		if @board.board[to.join.to_sym].class != Pieces::King
			take_out(from, to) if @board.board[to.join.to_sym] != " "
			@board.board[to.join.to_sym] = @board.board[from.join.to_sym]
			@board.board[to.join.to_sym].moved = true
			@board.board[to.join.to_sym].times_moved += 1
			@board.board[to.join.to_sym].current_position = convert(to_cloned)
			@board.board[from.join.to_sym] = " "
		end
	end

	def take_out(from, to)
		if @board.board[from.join.to_sym].white != @board.board[to.join.to_sym].white
			@board.board[from.join.to_sym].white ? @taken_black << @board.board[to.join.to_sym] : @taken_white << @board.board[to.join.to_sym]
		else
			invalid_move
		end
	end

	def pawn_take_out(from, to)
		from_cloned = from.clone
		to_cloned = to.clone
		if [-7,-9,7,9].include?(convert(to_cloned) - convert(from_cloned)) && @board.board[from.join.to_sym].white != @board.board[to.join.to_sym].white
			if [1,2,3,4,5,6,7,8,57,58,59,60,61,62,63,64].include?(convert(to_cloned))
				take_out(from, to)
				promote(from, to)
			else
				take_out(from, to)
				place_piece(from, to)
			end
		else
			invalid_move
		end
	end

	def pawn_play(from, to)
		from_cloned = from.clone
		to_cloned = to.clone
		if !@board.board[from.join.to_sym].legal_move?(convert(to_cloned))
			check_mate(from, to)
			pawn_take_out(from, to)
		elsif @board.board[from.join.to_sym].legal_move?(convert(to_cloned)) && @board.board[to.join.to_sym] == " "
			if [1,2,3,4,5,6,7,8,57,58,59,60,61,62,63,64].include?(convert(to_cloned))
				promote(from, to)
			else
				place_piece(from, to)
			end
		else
			invalid_move
		end
	end

	def play(from, to)
		to_cloned = to.clone
		if @board.board[from.join.to_sym].class == Pieces::Pawn 
			pawn_play(from, to)
		elsif @board.board[from.join.to_sym].legal_move?(convert(to_cloned))
			if @board.board[from.join.to_sym].class == Pieces::Knight
				place_piece(from, to)
			elsif @board.board[from.join.to_sym].legal_list(convert(to_cloned)).all? { |n| @board.board[convert_back(n).join.to_sym] == " " }
				if @board.board[from.join.to_sym].class == Pieces::Rook
					castle(from, to)
				else
					place_piece(from, to)
				end
			else
				invalid_move
			end
		else
			invalid_move
		end
	end

	def black_play
		@player_2.make_move
		if !@player_2.from.nil?
			exit_game if @player_2.from.join == "e0"
		end
		play(@player_2.from, @player_2.to)
		turn unless @player_2.from.join == "e0"
	end

	def white_play
		@player_1.make_move
		if !@player_1.from.nil?
			exit_game if @player_1.from.join == "e0"
		end
		play(@player_1.from, @player_1.to)
		turn unless @player_1.from.join == "e0"
	end

	def check?
		@board.board.each do |key, value|
			if value != " "
				value.legal_move_list.each do |n|
					if (1..64).include?(value.current_position + n) && @board.board[convert_back(value.current_position + n).join.to_sym].class == Pieces::King
						if @board.board[convert_back(value.current_position + n).join.to_sym].white != value.white
							if (value.class == Pieces::Knight || value.legal_move?(value.current_position + n)) && value.legal_list(value.current_position + n).all? { |x| @board.board[convert_back(x).join.to_sym] == " " }
								return true
							end
						end
					end
				end
			end
		end
		return false
	end

	def check_mate(from, to)
		if @board.board[to.join.to_sym] != " " && @board.board[to.join.to_sym].class == Pieces::King
			puts "Checkmate! #{@turns.odd? ? "Black" : "White"} wins!"
			@over = true
		end
	end


	def proceed
		@board.display
		until over?
			if @turns.odd?
				check_enpassant(@player_1.from, @player_1.to)
				whose_turn
				black_play
				@board.display
				check_mate(@player_2.from, @player_2.to)
			else
				check_enpassant(@player_2.from, @player_2.to)
				whose_turn
				white_play
				@board.display
				check_mate(@player_1.from, @player_1.to)
			end
			puts "#{@turns.odd? ? "Black" : "White"} check!" if check?
		end
	end

	def over?
		@over
	end
end

Game.new