module Turn
	
	def turn
		@turns += 1
	end

	def show_whose_turn
		@stream.puts "\n#{@player_1.name} has the white pieces. #{@player_2.name} has the black pieces." if @turns.zero? && @on_network
		STDOUT.puts "\n#{@player_1.name} has the white pieces. #{@player_2.name} has the black pieces." if @turns.zero?
		@output.puts @turns.odd? ? "\nIt is Black's turn!" : "\nIt is White's turn!" if !@comp || @turns.even?
	end

	# Shows the valid move of the computer
	def show_ai_move
		if @comp && @turns.odd?
			@output.puts "\nIt is Black's turn!"
			@output.puts "\n#{@player_2.from unless @player_2.from.nil?}" + " #{@player_2.to unless @player_2.to.nil?}\n"
		end
	end

	def show_board
		@board.display(STDOUT)
		@board.display(@stream) if @on_network
		@output.puts @turns.odd? ? "\nIt is Black's turn!" : "\nIt is White's turn!" if @on_network
		@output.puts "\nWaiting for the player to make a move..." if @on_network
	end

	def switch_stream
		if @on_network
			if @turns.even?
				@input = STDIN
				@output = STDOUT
			else
				@input = @stream
				@output = @stream
			end
		end
	end

	def set_current_player
		@player = @turns.odd? ? @player_2 : @player_1
	end

	def get_move
		@player.get_move(@output, @input, @board.board)
		@to = @player.to
		@from = @player.from
	end
end