class Board
	attr_accessor :board

	def initialize
		@board = {}
		prepare_board
	end

	def prepare_board
		letters = ("a".."h").to_a
		numbers = (1..8).to_a
		numbers.each do |n|
			letters.each do |l|
				@board[(l + n.to_s).to_sym] = " "
			end
		end
	end

	def split_rows
		board.values.each_slice(8).to_a
	end

	def set_blocks
		@t_line = "\u2550\u2550\u2550\u2566" 	# Top line of the board
		@m_line = "\u2550\u2550\u2550\u256C"	# Middle lines of the board
		@b_line = "\u2550\u2550\u2550\u2569"	# Bottom line of the board
		@hor = "\u2551"		# Horizantal lines
		@ver = "\u2550"		# Vertical lines
		@ltc = "\u2554"		# Left top center piece
		@rtc = "\u2557"		# Right top center piece
		@lmc = "\u2560"		# Left middle center piece
		@rmc = "\u2563"		# Right middle center piece
		@lbc = "\u255A"		# Left bottom center piece
		@rbc = "\u255D"		# Right bottom center piece
	end

	def display
		set_blocks
		rows = split_rows.reverse
		row_number = 8
		row_counter = 1
		square_counter = 1
		puts "    a   b   c   d   e   f   g   h"
		puts "  #{@ltc+@t_line+@t_line+@t_line+@t_line+@t_line+@t_line+@t_line+@ver+@ver+@ver+@rtc}"
		rows.each do |row|
			print "#{row_number} "
			row.each do |value|
				unless row_counter.odd?
					if square_counter.odd?
						print "#{@hor}\u2593#{value != " " ? value.sign + " ": "\u2593\u2593"}"
					else
						print "#{@hor} #{value != " " ? value.sign : " "} "
					end
				else
					if square_counter.odd?
						print "#{@hor} #{value != " " ? value.sign : " "} "
					else
						print "#{@hor}\u2593#{value != " " ? value.sign + " ": "\u2593\u2593"}"
					end
				end
				square_counter += 1
			end
			row_counter += 1
			print "#{@hor} #{row_number}"
			row_number -= 1
			if row_number > 0
				puts "\n  #{@lmc+@m_line+@m_line+@m_line+@m_line+@m_line+@m_line+@m_line+@ver+@ver+@ver+@rmc}"
			else
				puts "\n  #{@lbc+@b_line+@b_line+@b_line+@b_line+@b_line+@b_line+@b_line+@ver+@ver+@ver+@rbc}"
			end
		end
		puts "    a   b   c   d   e   f   g   h"
	end
end