#!/usr/bin/ruby
require_relative "lib/require_files.rb"

class Game
	include SpecialMoves
	include Technical
	include GameStart
	include GameFlow

	def initialize
		@board = Board.new
		@turns = 0
		@over = false
		@is_invalid = false
		give_options
		new_or_saved?
	end
end

Game.new