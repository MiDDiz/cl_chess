module GameStart
	def is_human?
		puts "Would you like to play against the computer?(y/n)"
		response = gets.chomp.downcase
		case response
		when "y" then return false
		when "n" then return true
		end
	end

	def intro
		system("clear")
		sleep 1
		@is_human = is_human?
		pick
		welcome
		set_player_name
		system("clear")
		sleep 1
		set_board
	end

	def pick
		@is_human ? play_with_human : play_with_ai
	end

	def welcome
		puts "=================================================="
		puts "Welcome to the command-line chess!".center(50)
		puts "In order to save and quit, type 'e0' as your move.".center(50)
		puts "Please read README for more info.".center(50)
		puts "You know the rules.".center(50)
		puts "So hop on and have fun!".center(50)
		puts "=================================================="
	end

	def set_player_name
		if @is_human
			@player_1.get_name
			@player_2.get_name
		else
			@player_1.get_name
		end
	end

	def play_with_human
		@player_1 = Players::Human.new(true)
		@player_2 = Players::Human.new
	end

	def play_with_ai
		@player_1 = Players::Human.new(true)
		@player_2 = Players::AI.new
	end

	def set_board
		keys = @board.board.keys
		keys1 = @player_1.pieces.keys
		keys2 = @player_1.pieces.keys

		keys[0..15].each do |key|
			@board.board[key] = @player_1.pieces[keys1.shift]
			@board.board[key].current_position = convert_to_number(key.to_s.chars)
		end

		keys[56..63].each do |key|
			@board.board[key] = @player_2.pieces[keys2.shift]
			@board.board[key].current_position = convert_to_number(key.to_s.chars)
		end

		keys[48..55].each do |key|
			@board.board[key] = @player_2.pieces[keys2.shift]
			@board.board[key].current_position = convert_to_number(key.to_s.chars)
		end
	end
end