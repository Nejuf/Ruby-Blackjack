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

	def length
		cards.length
	end
end