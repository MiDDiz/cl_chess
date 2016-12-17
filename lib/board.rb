class Board
	attr_accessor :board

	def initialize
		@board = {}
		@t_line = "\u2550\u2550\u2550\u2550\u2566" 	# Top line of the board
		@m_line = "\u2550\u2550\u2550\u2550\u256C"	# Middle lines of the board
		@b_line = "\u2550\u2550\u2550\u2550\u2569"	# Bottom line of the board
		@hor = "\u2551"		# Horizantal lines
		@ver = "\u2550"		# Vertical lines
		@ltc = "\u2554"		# Left top center piece
		@rtc = "\u2557"		# Right top center piece
		@lmc = "\u2560"		# Left middle center piece
		@rmc = "\u2563"		# Right middle center piece
		@lbc = "\u255A"		# Left bottom center piece
		@rbc = "\u255D"		# Right bottom center piece
		prepare_board
	end

	def display(output)
		rows = split_rows.reverse
		row_number = 8
		row_counter = 1
		square_counter = 1
		output.puts "\n     a    b    c    d    e    f    g    h"
		output.puts "  #{@ltc+@t_line+@t_line+@t_line+@t_line+@t_line+@t_line+@t_line+@ver+@ver+@ver+@ver+@rtc}"
		rows.each do |row|
			output.print "#{row_number} "
			row.each do |value|
				unless row_counter.odd?
					if square_counter.odd?
						output.print "#{@hor} #{value != " " ? value.sign : " "}  "
					else
						output.print "#{@hor}\u2593#{value != " " ? value.sign + " \u2593": "\u2593\u2593\u2593"}"
					end
				else
					if square_counter.odd?
						output.print "#{@hor}\u2593#{value != " " ? value.sign + " \u2593": "\u2593\u2593\u2593"}"
					else
						output.print "#{@hor} #{value != " " ? value.sign : " "}  "
					end
				end
				square_counter += 1
			end
			row_counter += 1
			output.print "#{@hor} #{row_number}"
			row_number -= 1
			if row_number > 0
				output.puts "\n  #{@lmc+@m_line+@m_line+@m_line+@m_line+@m_line+@m_line+@m_line+@ver+@ver+@ver+@ver+@rmc}"
			else
				output.puts "\n  #{@lbc+@b_line+@b_line+@b_line+@b_line+@b_line+@b_line+@b_line+@ver+@ver+@ver+@ver+@rbc}"
			end
		end
		output.puts "     a    b    c    d    e    f    g    h"
	end

	private

	# Sets the keys of the board hash and assigns them to a single space string
	def prepare_board
		(1..8).each do |n|
			("a".."h").each do |l|
				@board[(l + n.to_s).to_sym] = " "
			end
		end
	end

	# Splits the board into 8 rows of 8 squares
	def split_rows
		return board.values.each_slice(8).to_a
	end
end