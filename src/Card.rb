class Card
	STANDARD_SUITS = %w( CLUBS HEARTS SPADES DIAMONDS )

	attr_accessor :rank, :suit

	def initialize(rank, suit)
		@rank = rank
		@suit = suit
		@face_down = true
	end

	def is_down?
		@face_down
	end

	def flip
		@face_down = !@face_down
	end

	def show
		@face_down = false
	end

	def hide
		@face_down = true
	end

end