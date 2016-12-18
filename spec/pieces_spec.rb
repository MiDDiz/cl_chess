require_relative "../lib/pieces.rb"
require_relative "spec_helper.rb"

# Piece Base
describe "Piece" do
	before do
		@piece = Pieces::Piece.new(true)
	end

	describe "#str_legal?" do
		it "returns true when moved vertically" do
			expect(@piece.send(:str_legal?, :a1, :a2)).to be true
		end

		it "returns true when moved horizontally" do
			expect(@piece.send(:str_legal?, :a1, :b1)).to be true
		end

		it "returns false when moved diagonally" do
			expect(@piece.send(:str_legal?, :a1, :b2)).to be false
		end
	end

	describe "#dia_legal?" do
		it "returns true when moved diagonally" do
			expect(@piece.send(:dia_legal?, :a1, :b2)).to be true
		end

		it "returns false when moved vertically" do
			expect(@piece.send(:dia_legal?, :a1, :a2)).to be false
		end

		it "returns false when moved horizontally" do
			expect(@piece.send(:dia_legal?, :a1, :b1)).to be false
		end
	end

	describe "#hor_line" do
		it "returns the next square on the route" do
			expect(@piece.send(:hor_line, :a1, :c1)).to eql(:b1)
		end
	end

	describe "#ver_line" do
		it "returns the next square on the route" do
			expect(@piece.send(:ver_line, :a1, :a3)).to eql(:a2)
		end
	end

	describe "#dia_line" do
		it "returns the next square on the route" do
			expect(@piece.send(:dia_line, :a1, :c3)).to eql(:b2)
		end
	end
end

# Pawn
describe "Pawn" do
	before do
		@pawn = Pieces::Pawn.new(true)
	end

	describe "#legal_move?" do
		it "returns true when moved one square ahead" do
			expect(@pawn.legal_move?(:a2, :a3)).to be true
		end

		it "returns true when moved two squares ahead" do
			expect(@pawn.legal_move?(:a2, :a4)).to be true
		end

		it "returns false when moved three squares ahead" do
			expect(@pawn.legal_move?(:a2, :a5)).to be false
		end

		it "returns false when moved backwards" do
			expect(@pawn.legal_move?(:a2, :a1)).to be false
		end

		it "returns false when moved horizontally" do
			expect(@pawn.legal_move?(:a1, :e1)).to be false
		end

		it "returns false when moved in an L shape" do
			expect(@pawn.legal_move?(:d4, :e6)).to be false
		end
	end
end

# Rook
describe "Rook" do
	before do
		@rook = Pieces::Rook.new(true)
	end

	describe "#legal_move?" do
		it "returns true when moved one square ahead" do
			expect(@rook.legal_move?(:a1, :a2)).to be true
		end

		it "returns true when moved four squares ahead" do
			expect(@rook.legal_move?(:a1, :a5)).to be true
		end

		it "returns true when moved one square backwards" do
			expect(@rook.legal_move?(:a5, :a4)).to be true
		end

		it "returns true when moved four squares backwards" do
			expect(@rook.legal_move?(:a5, :a1)).to be true
		end

		it "returns true when moved one square to right" do
			expect(@rook.legal_move?(:a1, :b1)).to be true
		end

		it "returns true when moved four squares to right" do
			expect(@rook.legal_move?(:a1, :e1)).to be true
		end

		it "returns true when moved one square to left" do
			expect(@rook.legal_move?(:e1, :d1)).to be true
		end

		it "returns true when moved four squares to left" do
			expect(@rook.legal_move?(:e1, :a1)).to be true
		end

		it "returns false when moved diagonally" do
			expect(@rook.legal_move?(:a1, :c3)). to be false
		end

		it "returns false when moved in an L shape" do
			expect(@rook.legal_move?(:d4, :e6)).to be false
		end
	end

	describe "#legal_list" do
		it "return the list of all the squares up to the destination" do
			expect(@rook.legal_list(:a1, :h1)).to eql([:b1, :c1, :d1, :e1, :f1, :g1])
		end
	end
end

# Bishop
describe "Bishop" do
	before do
		@bishop = Pieces::Bishop.new(true)
	end

	describe "#legal_move?" do
		it "returns true when moved one square up right" do
			expect(@bishop.legal_move?(:a1, :b2)).to be true
		end

		it "returns true when moved four squares up right" do
			expect(@bishop.legal_move?(:a1, :e5)).to be true
		end

		it "returns true when moved one square up left" do
			expect(@bishop.legal_move?(:h1, :g2)).to be true
		end

		it "returns true when moved four squares up left" do
			expect(@bishop.legal_move?(:h1, :d5)).to be true
		end

		it "returns true when moved one square down right" do
			expect(@bishop.legal_move?(:a8, :b7)).to be true
		end

		it "returns true when moved four squares down right" do
			expect(@bishop.legal_move?(:a8, :e4)).to be true
		end

		it "returns true when moved one square down left" do
			expect(@bishop.legal_move?(:h8, :g7)).to be true
		end

		it "returns true when moved four squares down left" do
			expect(@bishop.legal_move?(:h8, :d4)).to be true
		end

		it "returns false when moved horizontally" do
			expect(@bishop.legal_move?(:a1, :e1)).to be false
		end

		it "returns false when moved vertically" do
			expect(@bishop.legal_move?(:a1, :a5)).to be false
		end

		it "returns false when moved in an L shape" do
			expect(@bishop.legal_move?(:d4, :e6)).to be false
		end
	end

	describe "#legal_list" do
		it "return the list of all the squares up to the destination" do
			expect(@bishop.legal_list(:a1, :h8)).to eql([:b2, :c3, :d4, :e5, :f6, :g7])
		end
	end
end

# Queen
describe "Queen" do
	before do
		@queen = Pieces::Queen.new(true)
	end

	describe "#legal_move?" do
		it "returns true when moved one square ahead" do
			expect(@queen.legal_move?(:a1, :a2)).to be true
		end

		it "returns true when moved four squares ahead" do
			expect(@queen.legal_move?(:a1, :a5)).to be true
		end

		it "returns true when moved one square backwards" do
			expect(@queen.legal_move?(:a5, :a4)).to be true
		end

		it "returns true when moved four squares backwards" do
			expect(@queen.legal_move?(:a5, :a1)).to be true
		end

		it "returns true when moved one square to right" do
			expect(@queen.legal_move?(:a1, :b1)).to be true
		end

		it "returns true when moved four squares to right" do
			expect(@queen.legal_move?(:a1, :e1)).to be true
		end

		it "returns true when moved one square to left" do
			expect(@queen.legal_move?(:e1, :d1)).to be true
		end

		it "returns true when moved four squares to left" do
			expect(@queen.legal_move?(:e1, :a1)).to be true
		end

		it "returns true when moved one square up right" do
			expect(@queen.legal_move?(:a1, :b2)).to be true
		end

		it "returns true when moved four squares up right" do
			expect(@queen.legal_move?(:a1, :e5)).to be true
		end

		it "returns true when moved one square up left" do
			expect(@queen.legal_move?(:h1, :g2)).to be true
		end

		it "returns true when moved four squares up left" do
			expect(@queen.legal_move?(:h1, :d5)).to be true
		end

		it "returns true when moved one square down right" do
			expect(@queen.legal_move?(:a8, :b7)).to be true
		end

		it "returns true when moved four squares down right" do
			expect(@queen.legal_move?(:a8, :e4)).to be true
		end

		it "returns true when moved one square down left" do
			expect(@queen.legal_move?(:h8, :g7)).to be true
		end

		it "returns true when moved four squares down left" do
			expect(@queen.legal_move?(:h8, :d4)).to be true
		end

		it "returns false when moved in an L shape" do
			expect(@queen.legal_move?(:d4, :e6)).to be false
		end
	end

	describe "#legal_list" do
		it "return the list of all the squares up to the destination" do
			expect(@queen.legal_list(:a1, :h8)).to eql([:b2, :c3, :d4, :e5, :f6, :g7])
		end

		it "return the list of all the squares up to the destination" do
			expect(@queen.legal_list(:a1, :h1)).to eql([:b1, :c1, :d1, :e1, :f1, :g1])
		end
	end
end

# Knight
describe "Knight" do
	before do
		@knight = Pieces::Knight.new(true)
	end

	describe "#legal_move?" do
		it "returns true when moved in an L shape (alt 1)" do
			expect(@knight.legal_move?(:d4, :e6)).to be true
		end

		it "returns true when moved in an L shape (alt 2)" do
			expect(@knight.legal_move?(:d4, :f5)).to be true
		end

		it "returns true when moved in an L shape (alt 3)" do
			expect(@knight.legal_move?(:d4, :c6)).to be true
		end

		it "returns true when moved in an L shape (alt 4)" do
			expect(@knight.legal_move?(:d4, :b5)).to be true
		end

		it "returns true when moved in an L shape (alt 5)" do
			expect(@knight.legal_move?(:d4, :e2)).to be true
		end

		it "returns true when moved in an L shape (alt 6)" do
			expect(@knight.legal_move?(:d4, :f3)).to be true
		end

		it "returns true when moved in an L shape (alt 7)" do
			expect(@knight.legal_move?(:d4, :c2)).to be true
		end

		it "returns true when moved in an L shape (alt 8)" do
			expect(@knight.legal_move?(:d4, :b3)).to be true
		end

		it "returns false when moved diagonally" do
			expect(@knight.legal_move?(:a1, :c3)). to be false
		end

		it "returns false when moved horizontally" do
			expect(@knight.legal_move?(:a1, :e1)).to be false
		end

		it "returns false when moved vertically" do
			expect(@knight.legal_move?(:a1, :a5)).to be false
		end
	end
end

# King
describe "King" do
	before do
		@king = Pieces::King.new(true)
	end

	describe "#legal_move?" do
		it "return true when moved one square upwards" do
			expect(@king.legal_move?(:a1, :a2)).to be true
		end

		it "return true when moved one square downwards" do
			expect(@king.legal_move?(:a2, :a1)).to be true
		end

		it "return true when moved one square to right" do
			expect(@king.legal_move?(:a1, :b1)).to be true
		end

		it "return true when moved one square to left" do
			expect(@king.legal_move?(:b1, :a1)).to be true
		end

		it "return true when moved one square up right" do
			expect(@king.legal_move?(:a1, :b2)).to be true
		end

		it "return true when moved one square up left" do
			expect(@king.legal_move?(:b1, :a2)).to be true
		end

		it "return true when moved one square down right" do
			expect(@king.legal_move?(:a2, :b1)).to be true
		end

		it "return true when moved one square down left" do
			expect(@king.legal_move?(:b2, :a1)).to be true
		end

		it "return false when moved two squares upwards" do
			expect(@king.legal_move?(:a1, :a3)).to be false
		end

		it "return false when moved two squares downwards" do
			expect(@king.legal_move?(:a3, :a1)).to be false
		end

		it "return false when moved two squares to right" do
			expect(@king.legal_move?(:a1, :c1)).to be false
		end

		it "return false when moved two squares to left" do
			expect(@king.legal_move?(:c1, :a1)).to be false
		end

		it "return false when moved two squares up right" do
			expect(@king.legal_move?(:a1, :c3)).to be false
		end

		it "return false when moved two squares up left" do
			expect(@king.legal_move?(:c1, :a3)).to be false
		end

		it "return false when moved two squares down right" do
			expect(@king.legal_move?(:a3, :c1)).to be false
		end

		it "return false when moved two squares down left" do
			expect(@king.legal_move?(:c3, :a1)).to be false
		end

		it "returns false when moved in an L shape" do
			expect(@king.legal_move?(:d4, :e6)).to be false
		end
	end
end