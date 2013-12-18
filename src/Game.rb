require('./src/Deck')
require('./src/Hand')
require('./src/HumanPlayer')
require('./src/ComputerPlayer')
require('./src/Prompter')

class Game
	include Prompter

	attr_accessor :deck, :players
	attr_reader :dealer_hand

	def start
		taken_names = %w( player dealer comp1 comp2 comp3 )

		@deck = Deck.new
		@players = []
		@dealer_hand = Hand.new

		human_count = prompt('How many human players? (1-4)', 'Invalid input.', %w( 1 2 3 4 )).to_i
		human_count.times do 
			@players << HumanPlayer.new(taken_names)
			taken_names << @players.last.name
		end

		(4-@players.length).times do |num|
			@players << ComputerPlayer.new("comp#{num}")
		end

		game_loop
	end

	def game_loop
		until true == false
			puts "loop"
		end
	end
end