require "yaml"

module Technical
	class InvalidMove < Exception
	end

	def invalid_move
		begin
			raise InvalidMove, "!!! INVALID MOVE !!!"
		rescue InvalidMove => msg
			puts "\n===================="
			puts "#{msg}".center(20)
			puts "===================="
			@turns.odd? ? black_play : white_play
		end
	end

	def convert(move)
		begin
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
		rescue TypeError
			puts "\n================================================================="
			puts "!!! INVALID INPUT !!!".center(65)
			puts "The format of your input should be as follows: a4, b1, d8, etc..."
			puts "================================================================="
			@turns.odd? ? black_play : white_play
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

	def options
		if Dir.exists?("../saves")
			puts "Would you like to load a saved game?"
			@choice ||= gets.chomp
		end
	end

	def save
		config = {player_1: @player_1, player_2: @player_2, board: @board, turns: @turns, taken_black: @taken_black, taken_white: @taken_white}
		Dir.mkdir("../saves") unless Dir.exists?("../saves")
		File.open("../saves/#{@player_1.name + "_vs_" +@player_2.name}.txt", "w") { |file| file.puts(YAML::dump(config)) }
	end

	def load
		if File.exist?("../saves/#{@player_1.name + "_vs_" +@player_2.name}.txt")
			file = File.read("../saves/#{@player_1.name + "_vs_" +@player_2.name}.txt")
			config = YAML::load(file)
			@player_1 = config[:player_1]
			@player_2 = config[:player_2]
			@board = config[:board]
			@turns = config[:turns]
			@taken_black = config[:taken_black]
			@taken_white = config[:taken_white]
			system("clear")
			proceed
		else
			puts "\n"
			puts "NO SAVED GAMES FOUND!".center(60)
			puts "Starting a new game...".center(60)
			puts "\n"
			sleep 3
			start
			proceed
		end
	end

	def new_or_saved
		if @choice == "y"
			print "Enter White Player's name: "
			@player_1.name = gets.chomp.downcase.capitalize
			print "Enter Black Player's name: "
			@player_2.name = gets.chomp.downcase.capitalize
			load
		else
			start
			proceed
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