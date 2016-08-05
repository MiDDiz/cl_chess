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
		@board.values.each_slice(8).to_a
	end

	def blocks
		@t_line = "\u2550\u2550\u2550\u2566"
		@m_line = "\u2550\u2550\u2550\u256C"
		@b_line = "\u2550\u2550\u2550\u2569"
		@hor = "\u2551"
		@ver = "\u2550"
		@lcu = "\u2554"
		@rcu = "\u2557"
		@lcm = "\u2560"
		@rcm = "\u2563"
		@lcd = "\u255A"
		@rcd = "\u255D"
	end

	def display
		blocks
		rows = split_rows.reverse
		row_number = 8
		row_counter = 1
		square_counter = 1
		puts "    a   b   c   d   e   f   g   h"
		puts "  #{@lcu+@t_line+@t_line+@t_line+@t_line+@t_line+@t_line+@t_line+@ver+@ver+@ver+@rcu}"
		rows.each do |row|
			print "#{row_number} "
			row.each do |value|
				if !row_counter.odd?
					if square_counter.odd?
						print "#{@hor}\u2593#{value != " " ? value.sign : "\u2593"}\u2593"
					else
						print "#{@hor} #{value != " " ? value.sign : " "} "
					end
				else
					if square_counter.odd?
						print "#{@hor} #{value != " " ? value.sign : " "} "
					else
						print "#{@hor}\u2593#{value != " " ? value.sign : "\u2593"}\u2593"
					end
				end
				square_counter += 1
			end
			row_counter += 1
			print "#{@hor} #{row_number}"
			row_number -= 1
			if row_number > 0
				puts "\n  #{@lcm+@m_line+@m_line+@m_line+@m_line+@m_line+@m_line+@m_line+@ver+@ver+@ver+@rcm}"
			else
				puts "\n  #{@lcd+@b_line+@b_line+@b_line+@b_line+@b_line+@b_line+@b_line+@ver+@ver+@ver+@rcd}"
			end
		end
		puts "    a   b   c   d   e   f   g   h"
	end
end