require('./src/Card')

module CardCollection
	include Enumerable

	def cards
		@cards ||= []
	end

	def cards=(val)
		@cards = val
	end

	def each(&block)
		cards.each(&block)
	end

	def <=>(other_cards)
		cards.length <=> other_cards.length
	end

	def length
		cards.length
	end

	def shuffle
		cards.shuffle!
	end
end