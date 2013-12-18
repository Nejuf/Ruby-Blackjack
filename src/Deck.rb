require('./src/CardCollection')

class Deck
	include CardCollection

	def initialize(deck_type='standard')
		case deck_type
		when 'standard'
			Card::STANDARD_SUITS.each do |suit|
				(1..13).each do |rank|
					cards << Card.new(rank, suit)
				end
			end
		else
			raise ArgumentError, "Unrecognized deck type: #{deck_type}"
		end
	end

	def top
		cards.last
	end

	def bottom
		cards.first
	end

	def draw(num_cards=1)
		raise ArgumentError if num_cards < 1
		cards.pop(num_cards)
	end
end