require "yaml"

# ======================
# Save and load methods
# ======================
module Chess

	private
	
	def find_saved_game
		print "\nEnter White Player's name: "
		@name_1 = gets.chomp.downcase.capitalize
		print "Enter Black Player's name: "
		@name_2 = gets.chomp.downcase.capitalize
		File.exist?("saves/#{@name_1 + "_vs_" + @name_2}.txt") ? load_saved_game : start_new_game
	end

	def start_new_game
		puts
		puts "NO SAVED GAMES FOUND!".center(60)
		puts "Starting a new game...".center(60)
		puts "\n"
		sleep 1
		initialize_game
	end

	def save
		config = {player_1: @player_1, player_2: @player_2, board: @board, turns: @turns, en_passant_turns: @en_passant_turns, comp: @comp}
		Dir.mkdir("saves") unless Dir.exists?("saves")
		File.open("saves/#{@player_1.name + "_vs_" +@player_2.name}.txt", "w") { |file| file.puts(YAML::dump(config)) }
	end

	def load_saved_game
		file = File.read("saves/#{@name_1 + "_vs_" +@name_2}.txt")
		config = YAML::load(file)
		@player_1 = config[:player_1]
		@player_2 = config[:player_2]
		@board = config[:board]
		@turns = config[:turns]
		@en_passant_turns = config[:en_passant_turns]
		@comp = config[:comp]
		system("clear")
		show_board
		start_turn
	end
end