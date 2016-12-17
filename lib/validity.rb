module Validity

	def players_color?(from, to)
		return square(from).white != square(to).white ? true : false
	end

	def correct_color?(spot)
		if square(spot).white && !@turns.odd?
			return true
		elsif !square(spot).white && @turns.odd?
			return true
		else
			return false
		end
	end

	def valid_move?(from, to)
		if square(to) != " " && players_color?(from, to)
			return true
		elsif square(to) == " "
			return true
		else
			return false
		end
	end
end