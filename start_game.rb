require "socket"
require_relative "lib/game.rb"

network = ARGV.include?("network") ? true : false

if network
	server = TCPServer.open("0.0.0.0", 2000)

	loop do
		Thread.start(server.accept) do |stream|
			Game.new(stream: stream, network: network)
			stream.close
		end
		system('clear')
	end
else
	Game.new(network: network)
end