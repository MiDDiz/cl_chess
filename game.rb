#!/usr/bin/ruby
require_relative "lib/require_files.rb"

class Game
	include SpecialMoves
	include Helper
	include InitialTurn
	include GameFlow
	include Check
	include Validity
	include SaveLoad
	include Turn

	def initialize(config)
		@board = Board.new
		@turns = 0
		@over = false
		@human = true
		@on_network = config[:network] || false
		@stream = config[:stream]
		@output = @stream || STDOUT
		@input = @stream || STDIN
		give_options unless @on_network
		new_or_saved?
	end
end