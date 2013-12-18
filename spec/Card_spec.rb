require('./Blackjack.rb')

describe Card do

	context 'initialization' do
		before(:all) do
			@card = Card.new(4, Card::STANDARD_SUITS.first)
		end

		it 'is face-down by default' do
			expect(@card.is_down?).to be true
		end

	end

end