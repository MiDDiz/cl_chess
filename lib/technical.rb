require "yaml"

module Technical
	class InvalidMove < Exception
	end

	def invalid_move
		begin
			raise InvalidMove
		rescue InvalidMove
			puts "\n======================================================"
			puts "!!! INVALID MOVE !!!".center(50)
			puts "The specified piece is not allowed to make that move!"
			puts "======================================================"
			start
		end
	end

	def rescue_interrupt
		print "\nDo you really want to exit the game without saving?(y/n): "
		response = gets.chomp.downcase
		case response
		when "y" then exit
		when "n"
			print "\nDo you want to continue to play or save and exit? Type 'c' for continue and 's' for save and exit: "
			choice = gets.chomp.downcase
			case choice
			when "c" then start
			when "s" then exit_game
			end
		end
	end

	def error_info
		puts "\n======================================================================"
		puts "!!! INVALID INPUT !!!".center(65)
		puts "Check your input:"
		puts "  * The format of your input should be as follows: a4, b1, d8, etc..."
		puts "  * There might not be any piece on the spot you've specified."
		puts "======================================================================"
	end

	def convert(move)
		unless move.nil?
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
	end

	def convert_back(move)
		if [8,16,24,32,40,48,56,64].include?(move)
			move_0 = "h"
			move_1 = (move) / 8
		else
			move_0 = ((move) % 8) - 1
			move_1 = ((move) / 8) + 1
		end
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

	def change(number)
		case number
		when 0 then number = "a"
		when 1 then number = "b"
		when 2 then number = "c"
		when 3 then number = "d"
		when 4 then number = "e"
		when 5 then number = "f"
		when 6 then number = "g"
		when 7 then number = "h"
		end
		return number
	end

	def options
		if Dir.exists?("../saves")
			puts "Would you like to load a saved game?(y/n)"
			@choice = gets.chomp
		end
	end

	def new_or_saved
		if @choice == "y"
			print "Enter White Player's name: "
			@name_1 = gets.chomp.downcase.capitalize
			print "Enter Black Player's name: "
			@name_2 = gets.chomp.downcase.capitalize
			load_or_new
		else
			intro
			start
		end
	end

	def save
		config = {player_1: @player_1, player_2: @player_2, board: @board, turns: @turns, en_passant_turns: @en_passant_turns, response: @response}
		Dir.mkdir("../saves") unless Dir.exists?("../saves")
		File.open("../saves/#{@player_1.name + "_vs_" +@player_2.name}.txt", "w") { |file| file.puts(YAML::dump(config)) }
	end

	def load_or_new
		if File.exist?("../saves/#{@name_1 + "_vs_" +@name_2}.txt")
			load_game
		else
			new_game
		end
	end

	def load_game
		file = File.read("../saves/#{@name_1 + "_vs_" +@name_2}.txt")
		config = YAML::load(file)
		@player_1 = config[:player_1]
		@player_2 = config[:player_2]
		@board = config[:board]
		@turns = config[:turns]
		@en_passant_turns = config[:en_passant_turns]
		@response = config[:response]
		system("clear")
		start
	end

	def new_game
		system("clear")
		puts "NO SAVED GAMES FOUND!".center(60)
		puts "Starting a new game...".center(60)
		puts "\n"
		sleep 3
		intro
		start
	end

	def check_exit
		to = @turns.odd? ? @player_2.to : @player_1.to
		from = @turns.odd? ? @player_2.from : @player_1.from
		if !from.nil?
			exit_game if from.join == "e0" || to.join == "e0"
		end
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