require "socket"
require_relative "lib/game.rb"

def give_options
	puts "COMMANDLINE CHESS".center(50)
	puts "\n0 => README"
	puts "1 => Start a new game"
	puts "2 => Load a saved game"
	puts "3 => Play on the network"
	puts "4 => Play with computer"
	puts "5 => Exit"
	print "\nPick an action: "

	case gets.chomp
	when "0"
		instr = File.open('README.txt') { |f| f.read }
		puts instr
		give_options
	when "1"
		Game.new
	when "2"
		Game.new(saved: true)
	when "3"
		server = TCPServer.open("0.0.0.0", 2000)

		loop do
			Thread.start(server.accept) do |stream|
				Game.new(stream: stream, network: true)
				stream.close
			end
		end
	when "4"
		Game.new(comp: true)
	when "5"
		exit
	else
		give_options
	end
end

give_options