require_relative "../board.rb"

describe "board" do

	before do
		@board = Board.new
	end
	
	describe "#display" do
		
		context "when empty" do

			it "displays the current state of the board" do
				expect { @board.display }.to output("    a   b   c   d   e   f   g   h\n  +---+---+---+---+---+---+---+---+\n8 |   |   |   |   |   |   |   |   |\n  +---+---+---+---+---+---+---+---+\n7 |   |   |   |   |   |   |   |   |\n  +---+---+---+---+---+---+---+---+\n6 |   |   |   |   |   |   |   |   |\n  +---+---+---+---+---+---+---+---+\n5 |   |   |   |   |   |   |   |   |\n  +---+---+---+---+---+---+---+---+\n4 |   |   |   |   |   |   |   |   |\n  +---+---+---+---+---+---+---+---+\n3 |   |   |   |   |   |   |   |   |\n  +---+---+---+---+---+---+---+---+\n2 |   |   |   |   |   |   |   |   |\n  +---+---+---+---+---+---+---+---+\n1 |   |   |   |   |   |   |   |   |\n  +---+---+---+---+---+---+---+---+\n").to_stdout
			end
		end

		context "when there are spots occupied" do

			it "displays the current state of the board" do
				@board.board[0][1] = "X"
				@board.board[0][0] = "O"
				expect { @board.display }.to output("    a   b   c   d   e   f   g   h\n  +---+---+---+---+---+---+---+---+\n8 |   |   |   |   |   |   |   |   |\n  +---+---+---+---+---+---+---+---+\n7 |   |   |   |   |   |   |   |   |\n  +---+---+---+---+---+---+---+---+\n6 |   |   |   |   |   |   |   |   |\n  +---+---+---+---+---+---+---+---+\n5 |   |   |   |   |   |   |   |   |\n  +---+---+---+---+---+---+---+---+\n4 |   |   |   |   |   |   |   |   |\n  +---+---+---+---+---+---+---+---+\n3 |   |   |   |   |   |   |   |   |\n  +---+---+---+---+---+---+---+---+\n2 |   |   |   |   |   |   |   |   |\n  +---+---+---+---+---+---+---+---+\n1 | O | X |   |   |   |   |   |   |\n  +---+---+---+---+---+---+---+---+\n").to_stdout
			end
		end
	end

	describe "#occupied?" do

		it "returns true if there is a piece in the spot the user intends to play" do
			@board.board[0][0] =  "X"
			expect(@board.occupied?([0, 0])).to be true
		end
	end

end