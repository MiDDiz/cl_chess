require_relative "../player.rb"

describe "Player" do

	before do
		@player = Player.new
	end
	
	describe "#get_name" do
		it "asks for the first player's name" do
			expect { @player.get_name }.to output("Enter Player 1's name: ").to_stdout
		end

		it "asks for the second player's name" do
			expect { @player.get_name }.to output("Enter Player 2's name: ").to_stdout
		end
	end
end