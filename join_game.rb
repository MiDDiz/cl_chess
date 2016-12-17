require "socket"

hostname = ARGV[0]
port = 2000
stream = TCPSocket.open(hostname, port)

system('clear')

while line = stream.gets.chomp
	puts line
	if /:$/ =~ line
		answer = STDIN.gets.chomp
		stream.puts(answer)
	elsif /^\s{3}={22}.+={22}\s{3}$/ =~ line
		break
	end
end
stream.close