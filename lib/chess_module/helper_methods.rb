# ====================================
# Helper methods for the overall game
# ====================================
module Chess

	private

	def square(spot)
		return @board.board[spot]
	end

	# Makes a random true or false
	def comp_pick
		case rand(2)
		when 1 then return true
		when 0 then return false
		end
	end

	def human_pick
		case @input.gets.chomp.downcase
		when "y" then return true
		when "n" then return false
		end
	end

	# Calculates corresponding square a piece is moves according to number of squares passed as the second argument.
	# A positive number means right (forward) move. A negative number means a left (backward) move. 'a', 'h', '1', '8'
	# signify the borders of the board.
	def calc_move(from, squares)
		from = from.to_s.chars
		while squares > 0
			if from[0] < "h"
				from[0] = from[0].next
			elsif from[1].to_i < 8
				from[1] = from[1].next
				from[0] = "a"
			end
			squares -= 1
		end
		while squares < 0
			if from[0] > "a"
				from[0] = (from[0].ord.pred).chr
			elsif from[1].to_i > 1
				from[1] = (from[1].to_i - 1).to_s
				from[0] = "h"
			end
			squares += 1
		end
		return from.join.to_sym
	end

	# Clones the board for checking if the current move of the current player gets itself into a check position
	def clone_board(from, to)
		board_cloned = @board.board.clone
		board_cloned[to], board_cloned[from] = board_cloned[from], " "
		return board_cloned
	end

	def raise_invalid_move
		if !@comp || @turns.even?
			@output.puts "\n======================================================"
			@output.puts "!!! INVALID MOVE !!!".center(50)
			@output.puts "The specified piece is not allowed to make that move!"
			@output.puts "======================================================"
		end
		start_turn
	end

	def raise_invalid_input
		@output.puts "\n======================================================================"
		@output.puts "!!! INVALID INPUT !!!".center(65)
		@output.puts "Check your input: "
		@output.puts "  * The format of your input should be as follows: 'a2 a4'"
		@output.puts "  * There might not be any piece on the spot you've specified."
		@output.puts "======================================================================"
	end

	def rescue_interrupt
		print "\nDo you really want to exit the game without saving?(y/n): "
		case gets.chomp.downcase
		when "y" then exit
		when "n"
			print "\nDo you want to continue to play or save and exit? Type 'c' for continue and 's' for save and exit: "
			case gets.chomp.downcase
			when "c" then start_turn
			when "s" then exit_game
			end
		end
	end

	def check_save_and_exit
		exit_game if @player.move == "save"
	end

	def exit_game
		at_exit do
			save
			puts
			puts "GOODBYE!".center(60)
		end
		exit
	end
end