class Player
	attr_reader :player, :color

	@@players = 0

	def initialize
		@player = nil
		@@players += 1
		@color = nil
	end

	def get_name
		print "Enter Player #{@@players}'s name: "
		@player = gets.chomp.downcase.capitalize
	end

	def set_color
		@color = @@players == 1 ? "white" : "black"
	end
end