require('./Blackjack.rb')

describe Deck do

	context "initialization" do
		before(:all) do
			@deck = Deck.new
		end

		it "builds a standard deck by default" do
			@deck.cards.each do |card|
				expect(Card::STANDARD_SUITS).to include(card.suit)
				expect(card.rank).to be >= 1
				expect(card.rank).to be <= 13
			end
		end

	end

end