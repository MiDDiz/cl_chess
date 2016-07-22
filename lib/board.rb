class Board
	attr_accessor :board

	def initialize
		@board = {a1: " ", b1: " ", c1: " ", d1: " ", e1: " ", f1: " ", g1: " ", h1: " ", 
				  a2: " ", b2: " ", c2: " ", d2: " ", e2: " ", f2: " ", g2: " ", h2: " ",
				  a3: " ", b3: " ", c3: " ", d3: " ", e3: " ", f3: " ", g3: " ", h3: " ", 
				  a4: " ", b4: " ", c4: " ", d4: " ", e4: " ", f4: " ", g4: " ", h4: " ", 
				  a5: " ", b5: " ", c5: " ", d5: " ", e5: " ", f5: " ", g5: " ", h5: " ", 
				  a6: " ", b6: " ", c6: " ", d6: " ", e6: " ", f6: " ", g6: " ", h6: " ", 
				  a7: " ", b7: " ", c7: " ", d7: " ", e7: " ", f7: " ", g7: " ", h7: " ", 
				  a8: " ", b8: " ", c8: " ", d8: " ", e8: " ", f8: " ", g8: " ", h8: " "}
	end

	def display
		puts "    a   b   c   d   e   f   g   h"\
			 "\n  +---+---+---+---+---+---+---+---+"\
			 "\n8 | #{@board[:a8] != " " ? @board[:a8].sign : " "} | #{@board[:b8] != " " ? @board[:b8].sign : " "} | #{@board[:c8] != " " ? @board[:c8].sign : " "} | #{@board[:d8] != " " ? @board[:d8].sign : " "} | #{@board[:e8] != " " ? @board[:e8].sign : " "} | #{@board[:f8] != " " ? @board[:f8].sign : " "} | #{@board[:g8] != " " ? @board[:g8].sign : " "} | #{@board[:h8] != " " ? @board[:h8].sign : " "} | 8"\
			 "\n  +---+---+---+---+---+---+---+---+"\
			 "\n7 | #{@board[:a7] != " " ? @board[:a7].sign : " "} | #{@board[:b7] != " " ? @board[:b7].sign : " "} | #{@board[:c7] != " " ? @board[:c7].sign : " "} | #{@board[:d7] != " " ? @board[:d7].sign : " "} | #{@board[:e7] != " " ? @board[:e7].sign : " "} | #{@board[:f7] != " " ? @board[:f7].sign : " "} | #{@board[:g7] != " " ? @board[:g7].sign : " "} | #{@board[:h7] != " " ? @board[:h7].sign : " "} | 7"\
			 "\n  +---+---+---+---+---+---+---+---+"\
			 "\n6 | #{@board[:a6] != " " ? @board[:a6].sign : " "} | #{@board[:b6] != " " ? @board[:b6].sign : " "} | #{@board[:c6] != " " ? @board[:c6].sign : " "} | #{@board[:d6] != " " ? @board[:d6].sign : " "} | #{@board[:e6] != " " ? @board[:e6].sign : " "} | #{@board[:f6] != " " ? @board[:f6].sign : " "} | #{@board[:g6] != " " ? @board[:g6].sign : " "} | #{@board[:h6] != " " ? @board[:h6].sign : " "} | 6"\
			 "\n  +---+---+---+---+---+---+---+---+"\
			 "\n5 | #{@board[:a5] != " " ? @board[:a5].sign : " "} | #{@board[:b5] != " " ? @board[:b5].sign : " "} | #{@board[:c5] != " " ? @board[:c5].sign : " "} | #{@board[:d5] != " " ? @board[:d5].sign : " "} | #{@board[:e5] != " " ? @board[:e5].sign : " "} | #{@board[:f5] != " " ? @board[:f5].sign : " "} | #{@board[:g5] != " " ? @board[:g5].sign : " "} | #{@board[:h5] != " " ? @board[:h5].sign : " "} | 5"\
			 "\n  +---+---+---+---+---+---+---+---+"\
			 "\n4 | #{@board[:a4] != " " ? @board[:a4].sign : " "} | #{@board[:b4] != " " ? @board[:b4].sign : " "} | #{@board[:c4] != " " ? @board[:c4].sign : " "} | #{@board[:d4] != " " ? @board[:d4].sign : " "} | #{@board[:e4] != " " ? @board[:e4].sign : " "} | #{@board[:f4] != " " ? @board[:f4].sign : " "} | #{@board[:g4] != " " ? @board[:g4].sign : " "} | #{@board[:h4] != " " ? @board[:h4].sign : " "} | 4"\
			 "\n  +---+---+---+---+---+---+---+---+"\
			 "\n3 | #{@board[:a3] != " " ? @board[:a3].sign : " "} | #{@board[:b3] != " " ? @board[:b3].sign : " "} | #{@board[:c3] != " " ? @board[:c3].sign : " "} | #{@board[:d3] != " " ? @board[:d3].sign : " "} | #{@board[:e3] != " " ? @board[:e3].sign : " "} | #{@board[:f3] != " " ? @board[:f3].sign : " "} | #{@board[:g3] != " " ? @board[:g3].sign : " "} | #{@board[:h3] != " " ? @board[:h3].sign : " "} | 3"\
			 "\n  +---+---+---+---+---+---+---+---+"\
			 "\n2 | #{@board[:a2] != " " ? @board[:a2].sign : " "} | #{@board[:b2] != " " ? @board[:b2].sign : " "} | #{@board[:c2] != " " ? @board[:c2].sign : " "} | #{@board[:d2] != " " ? @board[:d2].sign : " "} | #{@board[:e2] != " " ? @board[:e2].sign : " "} | #{@board[:f2] != " " ? @board[:f2].sign : " "} | #{@board[:g2] != " " ? @board[:g2].sign : " "} | #{@board[:h2] != " " ? @board[:h2].sign : " "} | 2"\
			 "\n  +---+---+---+---+---+---+---+---+"\
			 "\n1 | #{@board[:a1] != " " ? @board[:a1].sign : " "} | #{@board[:b1] != " " ? @board[:b1].sign : " "} | #{@board[:c1] != " " ? @board[:c1].sign : " "} | #{@board[:d1] != " " ? @board[:d1].sign : " "} | #{@board[:e1] != " " ? @board[:e1].sign : " "} | #{@board[:f1] != " " ? @board[:f1].sign : " "} | #{@board[:g1] != " " ? @board[:g1].sign : " "} | #{@board[:h1] != " " ? @board[:h1].sign : " "} | 1"\
			 "\n  +---+---+---+---+---+---+---+---+"\
			 "\n    a   b   c   d   e   f   g   h  "
	end
end