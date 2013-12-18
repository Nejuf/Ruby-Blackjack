require('./Blackjack.rb')

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

	it '#draw removes a card' do
		d = Deck.new
		len = d.length
		c = d.draw
		expect(c).to_not be_nil
		expect(len - d.length).to eq(1)
	end

end