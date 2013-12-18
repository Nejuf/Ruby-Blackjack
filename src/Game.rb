require('./src/Deck')
require('./src/Hand')

class Game

	attr_accessor :deck

	def initialize
		@deck = Deck.new
	end
end