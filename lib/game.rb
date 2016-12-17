require_relative "require_files.rb"

class Game
	include SpecialMoves
	include Helpers
	include InitialTurn
	include GameFlow
	include Check
	include Validity
	include SaveLoad
	include Turn

	def initialize(config={})
		@board = Board.new
		@turns = 0
		@over = false
		@comp = config[:comp] || false
		@on_network = config[:network] || false
		@stream = config[:stream]
		@saved = config[:saved] || false
		@output = @stream || STDOUT
		@input = @stream || STDIN
		pick_game
	end

	def pick_game
		if @saved
			find_saved_game
		else
			initialize_game
		end
	end
end