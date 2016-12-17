require "yaml"

module SaveLoad

	def give_options
		if Dir.exists?("saves")
			sleep 1
			puts "Would you like to load a saved game?(y/n)"
			@start_saved_game = gets.chomp.downcase
		end
	end

	def new_or_saved?
		if @start_saved_game == "y"
			print "Enter White Player's name: "
			@name_1 = gets.chomp.downcase.capitalize
			print "Enter Black Player's name: "
			@name_2 = gets.chomp.downcase.capitalize
			load_or_new?
		else
			intro
			start_game
		end
	end

	def new_game
		system("clear")
		puts "NO SAVED GAMES FOUND!".center(60)
		puts "Starting a new game...".center(60)
		puts "\n"
		sleep 2
		intro
		start_game
	end

	def save
		config = {player_1: @player_1, player_2: @player_2, board: @board, turns: @turns, en_passant_turns: @en_passant_turns, human: @human}
		Dir.mkdir("saves") unless Dir.exists?("saves")
		File.open("saves/#{@player_1.name + "_vs_" +@player_2.name}.txt", "w") { |file| file.puts(YAML::dump(config)) }
	end

	def load_or_new?
		File.exist?("saves/#{@name_1 + "_vs_" +@name_2}.txt") ? load_game : new_game
	end

	def load_game
		file = File.read("saves/#{@name_1 + "_vs_" +@name_2}.txt")
		config = YAML::load(file)
		@player_1 = config[:player_1]
		@player_2 = config[:player_2]
		@board = config[:board]
		@turns = config[:turns]
		@en_passant_turns = config[:en_passant_turns]
		@human = config[:human]
		system("clear")
		show_board
		start_game
	end
end