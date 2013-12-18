require('./src/CardCollection')

class Deck
	include CardCollection

	def initialize(deck_type='standard')
		case deck_type
		when 'standard'
					# puts "cards #{cards}"
					# puts "cards s #{self.cards}"
					puts "cards @ #{@cards}"
			Card::STANDARD_SUITS.each do |suit|
				(1..13).each do |rank|
					cards << Card.new(rank, suit)
				end
			end
		else
			raise ArgumentError, "Unrecognized deck type: #{deck_type}"
		end
	end

end