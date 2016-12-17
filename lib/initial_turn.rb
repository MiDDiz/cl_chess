module InitialTurn
	
	def intro
		system("clear")
		sleep 1
		pick_human_or_ai unless @on_network
		@human ? play_with_human : play_with_ai
		welcome
		set_player_name
		set_board
		show_board
	end

	def pick_human_or_ai
		puts "Would you like to play against the computer?(y/n)"
		case gets.chomp.downcase
		when "y" then @human = false
		when "n" then return @human = true
		end
	end

	def welcome
		puts "=================================================="
		puts "Welcome to the command-line chess!".center(50)
		puts "In order to save and quit, type 'e0' as your move.".center(50)
		puts "Please read README for more info.".center(50)
		puts "You know the rules.".center(50)
		puts "So hop on and have fun!".center(50)
		puts "=================================================="
		if @on_network
			@output.puts "=================================================="
			@output.puts "Welcome to the command-line chess!".center(50)
			@output.puts "In order to save and quit, type 'e0' as your move.".center(50)
			@output.puts "Please read README for more info.".center(50)
			@output.puts "You know the rules.".center(50)
			@output.puts "So hop on and have fun!".center(50)
			@output.puts "=================================================="
		end
	end

	def set_player_name
		if @human
			@player_1.get_name(STDOUT, STDIN)
			@player_2.get_name(@output, @input)
		else
			@player_1.get_name(@output, @input)
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

	def set_current_player
		@player = @turns.odd? ? @player_2 : @player_1
	end

	def set_board
		keys = @board.board.keys
		keys[0..15].each { |key| @board.board[key] = @player_1.pieces.shift }
		keys[56..63].each { |key| @board.board[key] = @player_2.pieces.shift }
		keys[48..55].each { |key| @board.board[key] = @player_2.pieces.shift }
	end
end