class Card
	STANDARD_SUITS = %w( CLUBS HEARTS SPADES DIAMONDS )

	def initialize(rank, suit)
		@rank = rank
		@suit = suit
	end
end