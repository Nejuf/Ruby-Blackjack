require('./src/Game')

describe Deck do

	context 'initialization' do
		before(:all) do
			@deck = Deck.new
		end

		it 'builds a standard deck by default' do
			@deck.cards.each do |card|
				expect(Card::STANDARD_SUITS).to include(card.suit)
				expect(card.rank).to be >= 1
				expect(card.rank).to be <= 13
			end
		end
	end

	it '#draw removes a card and returns it in array' do
		d = Deck.new
		len = d.length
		c = d.draw
		expect(c.length).to eq(1)
		expect(len - d.length).to eq(1)
	end

	it '#draw removes multiple card and returns them in array' do
		d = Deck.new
		len = d.length
		c = d.draw(3)
		expect(c.length).to eq(3)
		expect(len - d.length).to eq(3)
	end

end