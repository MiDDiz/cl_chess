require_relative "board.rb"
require_relative "player.rb"
require_relative "special_moves.rb"
require_relative "technical.rb"

class Game
	include SpecialMoves
	include Technical

	def initialize
		@board = Board.new
		@turns = 0
		@over = false
		options
		new_or_saved
	end

	def human?
		puts "Would you like to play against the computer?(y/n)"
		@response = gets.chomp.downcase
		case @response
		when "y" then @response = false
		when "n" then @response = true
		end
		return @response
	end

	def pick
		if human?
			human
		else
			ai
		end
	end

	def human
		@player_1 = Human.new(true)
		@player_2 = Human.new
	end

	def ai
		@player_1 = Human.new(true)
		@player_2 = AI.new
	end

	def intro
		system("clear")
		sleep 1
		pick
		welcome
		player_name
		system("clear")
		sleep 1
		set_board
	end

	def welcome
		puts "=================================================="
		puts "Welcome to the command-line chess!".center(50)
		puts "In order to save and quit, type 'e0' as your move!".center(50)
		puts "You know the rules!".center(50)
		puts "So hop on and have fun!".center(50)
		puts "=================================================="
	end

	def player_name
		if @response
			@player_1.get_name
			@player_2.get_name
		else
			@player_1.get_name
		end
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

	def show_move
		puts "From : #{@player_2.from.join unless @player_2.from.nil?}"
		puts "To   : #{@player_2.to.join unless @player_2.to.nil?}"
	end

	def human_play
		@turns.odd? ? @player_2.make_move : @player_1.make_move
		@to = @turns.odd? ? @player_2.to : @player_1.to
		@from = @turns.odd? ? @player_2.from : @player_1.from
	end

	def ai_play
		unless @turns.odd?
			@player_1.make_move
			@to = @player_1.to
			@from = @player_1.from
		else
			@from = @player_2.ai_from(@board.board)
			@to = @player_2.ai_to(@board.board)
			show_move if !@response && @turns.odd?
		end
	end

	def color_control?(from, to)
		if @board.board[from.join.to_sym].white != @board.board[to.join.to_sym].white
			return true
		else
			return false
		end
	end

	def correct_color?(spot)
		if @board.board[spot.join.to_sym].white && !@turns.odd?
			return true
		elsif !@board.board[spot.join.to_sym].white && @turns.odd?
			return true
		else
			return false
		end
	end

	def valid_move?(from, to)
		if @board.board[to.join.to_sym] != " " && color_control?(from, to)
			return true
		elsif @board.board[to.join.to_sym] == " "
			return true
		else
			return false
		end
	end

	def start
		begin
			@board.display
			until @check_mate
				proceed
			end
		rescue Interrupt
			rescue_interrupt
		end
	end

	def proceed
		puts "#{@turns.odd? ? "Black" : "White"} check!" if check?(@board.board)
		en_passant
		whose_turn
		play_piece
		@board.display
		turn
	end

	def play_piece
		if check?(@board.board)
			when_check
		else
			when_not_check
		end
		check_exit
		movement
	end

	def movement
		begin
			invalid_move unless valid_move?(@from, @to)
			if correct_color?(@from)
				en_passant_turn(@from, @to)
				play(@from, @to)
			else
				invalid_move
			end
		rescue NoMethodError
			error_info
			start
		end
	end

	def play(from, to)
		to_cloned = to.clone
		unless getting_into_check?(from, to)
			if @board.board[from.join.to_sym].class == Pieces::Pawn 
				pawn_play(from, to)
			elsif @board.board[from.join.to_sym].legal_move?(convert(to_cloned))
				if @board.board[from.join.to_sym].class == Pieces::Knight
					knight_play(from, to)
				elsif @board.board[from.join.to_sym].class == Pieces::King || @board.board[from.join.to_sym].legal_list(convert(to_cloned)).all? { |n| @board.board[convert_back(n).join.to_sym] == " " }
					rook_play(from, to)
				else
					invalid_move
				end
			else
				invalid_move
			end
		else
			invalid_move
		end
	end

	def knight_play(from, to)
		if from[1] != to[1]
			place_piece(from, to)
		else
			invalid_move
		end
	end

	def rook_play(from, to)
		if @board.board[from.join.to_sym].class == Pieces::Rook
			castle(from, to)
		else
			place_piece(from, to)
		end
	end

	def pawn_play(from, to)
		from_cloned = from.clone
		to_cloned = to.clone
		if !@board.board[from.join.to_sym].legal_move?(convert(to_cloned))
			pawn_capture(from, to)
		elsif @board.board[from.join.to_sym].legal_move?(convert(to_cloned)) && @board.board[to.join.to_sym] == " "
			pawn_promote(from, to)
		else
			invalid_move
		end
	end

	def pawn_promote(from, to)
		to_cloned = to.clone
		if [1,2,3,4,5,6,7,8,57,58,59,60,61,62,63,64].include?(convert(to_cloned))
			promote(from, to)
		else
			place_piece(from, to)
		end
	end

	def pawn_capture(from, to)
		from_cloned = from.clone
		to_cloned = to.clone
		if [-7,-9,7,9].include?(convert(to_cloned) - convert(from_cloned)) && @board.board[from.join.to_sym].white != @board.board[to.join.to_sym].white
			if [1,2,3,4,5,6,7,8,57,58,59,60,61,62,63,64].include?(convert(to_cloned))
				promote(from, to)
			else
				place_piece(from, to)
			end
		else
			invalid_move
		end
	end

	def place_piece(from, to)
		to_cloned = to.clone
		if @board.board[to.join.to_sym].class != Pieces::King
			@board.board[to.join.to_sym] = @board.board[from.join.to_sym]
			@board.board[to.join.to_sym].moved = true
			@board.board[to.join.to_sym].times_moved += 1
			@board.board[to.join.to_sym].current_position = convert(to_cloned)
			@board.board[from.join.to_sym] = " "
		else
			invalid_move
		end
	end

	def when_not_check
		if @response
			human_play
		else
			ai_play
		end
	end

	def getting_into_check?(from, to)
		board = @board.board.clone
		board[to.join.to_sym] = board[from.join.to_sym]
		board[from.join.to_sym] = " "
		if check?(board)
			if !@turns.odd? && board[to.join.to_sym].white
				return true
			elsif @turns.odd? && !board[to.join.to_sym].white
				return true
			else
				return false
			end
		else
			return false
		end
	end

	def check?(board)
		board.each do |key, value|
			if value != " "
				value.legal_move_list.each do |n|
					if (1..64).include?(value.current_position + n) && board[convert_back(value.current_position + n).join.to_sym].class == Pieces::King
						if board[convert_back(value.current_position + n).join.to_sym].white != value.white
							if value.class != Pieces::Knight
								if value.class == Pieces::Pawn
									return true
								elsif value.legal_move?(value.current_position + n) && value.legal_list(value.current_position + n).all? { |x| board[convert_back(x).join.to_sym] == " " }
									return true
								end
							elsif value.legal_move?(value.current_position + n)
								return true
							end
						end
					end
				end
			end
		end
		return false
	end

	def when_check
		get_move_while_check
		while_check
		out_of_check
	end

	def while_check
		while still_check?(@from, @to)
			game_over if checkmate?
			get_move_while_check
		end
	end

	def get_move_while_check
		puts "\nYou are in a check position. Please enter your move to get out of it."
		print "From : "
		if @response
			@from = gets.chomp.chars
			@from[1] = @from[1].to_i
		else
			@from = @player_2.ai_from(@board.board)
		end
		print "To   : "
		if @response
			@to = gets.chomp.chars
			@to[1] = @to[1].to_i
		else
			@to = @player_2.ai_to(@board.board)
		end
	end	

	def still_check?(from, to)
		board = @board.board.clone
		board[to.join.to_sym] = board[from.join.to_sym]
		board[from.join.to_sym] = " "
		return true if check?(board)
	end

	def out_of_check
		if @turns.odd?
			@player_2.from = @from
			@player_2.to = @to
		else
			@player_1.from = @from
			@player_1.to = @to
		end
	end

	def checkmate?
		board = @board.board
		board.each do |key, value|
			if value.class == Pieces::King
				if value.legal_move_list.all? { |m| board[convert_back(value.current_position + m).join.to_sym] != " "}
					value.legal_move_list.each do |m|
						if !board[convert_back(value.current_position + m).join.to_sym].nil? && board[convert_back(value.current_position + m).join.to_sym].white != value.white
							if still_check?(convert_back(value.current_position), convert_back(value.current_position + m))
								return true
							else
								return false
							end
						end
					end
				elsif value.legal_move_list.all? { |m| still_check?(convert_back(value.current_position), convert_back(value.current_position + m)) }
					return true
				else
					return false
				end
			end
		end
	end

	def game_over
		puts @turns.odd? ? "Checkmate! White Wins!" : "Checkmate! Black Wins!"
		exit
	end
end

Game.new