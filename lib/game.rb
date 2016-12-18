require_relative "require_files.rb"

class Game
	include Chess

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
end