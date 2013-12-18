require('./Blackjack.rb')

describe Hand do

	context 'initialization' do
		before(:all) do
			@hand = Hand.new
		end

		it 'has no cards' do
			expect(@hand.cards.length).to eq(0)
		end

	end

	context '#add' do
		before(:all) do
			@hand = Hand.new
		end

		before(:each) do
			@c1 = double('Card', :rank => 1, :suit => 'DIAMONDS')
			@c2 = double('Card', :rank => 3, :suit => 'HEARTS')
			@c3 = double('Card', :rank => 13, :suit => 'CLUBS')
		end

		it 'adds a card' do
			@hand = Hand.new
			@hand.add(@c1)
			expect(@hand.cards.length).to eq(1)
		end

		it 'adds multiple cards' do
			@hand = Hand.new
			@hand.add(*[@c2, @c3])
			expect(@hand.cards.length).to eq(2)
		end
	end

	context '#split' do

	end

end