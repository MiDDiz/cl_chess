require_relative "../lib/players.rb"
require_relative "spec_helper.rb"

describe "Comp" do
	before do
		@comp = Players::Comp.new
	end

	describe "#change_to_letter" do
		it "returns the letter equivalent of the numbers between 0 and 7" do
			expect(@comp.send(:change_to_letter, 6)).to eql('g')
		end

		it "returns nil for any number bigger than 7" do
			expect(@comp.send(:change_to_letter, 8)).to eql(nil)
		end
	end

	describe "#pick_move" do
		it "returns a valid key" do
			expect(@comp.send(:pick_move).to_s).to match(/^[a-h][1-8]$/)
		end

		it "returns a symbol" do
			expect(@comp.send(:pick_move).class).to eql(Symbol)
		end
	end
end