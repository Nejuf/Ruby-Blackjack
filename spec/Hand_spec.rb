require('./Blackjack.rb')

describe Hand do

	context 'initialization' do
		before(:all) do
			@hand = Hand.new
		end

		it 'has no cards' do
			expect(@hand.cards.length).to eq(0)
		end

		it 'has a bet of 0' do
			expect(@hand.bet).to eq(0)
		end
	end

	before(:each) do
		@c1 = double('Card', :rank => 1, :suit => 'DIAMONDS')
		@c2 = double('Card', :rank => 3, :suit => 'HEARTS')
		@c3 = double('Card', :rank => 13, :suit => 'CLUBS')
		@c4 = double('Card', :rank => 8, :suit => 'SPADES')
		@c5 = double('Card', :rank => 5, :suit => 'SPADES')
		@c6 = double('Card', :rank => 5, :suit => 'DIAMONDS')
		@c7 = double('Card', :rank => 1, :suit => 'CLUBS')
	end

	context '#add' do
		before(:all) do
			@hand = Hand.new
		end

		it 'adds a card' do
			@hand = Hand.new
			@hand.add(@c1)
			expect(@hand.cards.length).to eq(1)
		end

		it 'adds multiple cards' do
			@hand = Hand.new
			@hand.add(@c2, @c3)
			expect(@hand.cards.length).to eq(2)
		end
	end

	context '#points' do
		before(:each) do
			@hand = Hand.new
		end

		it 'considers face cards 10 points' do
			@hand.add(@c2, @c3)
			expect(@hand.points).to eq(13)
		end

		it 'identifies bust' do
			@hand.add(@c3, @c5)
			expect(@hand.bust?).to be false
			@hand.add(@c4)
			expect(@hand.bust?).to be true
		end

		it 'identifies blackjack' do
			expect(@hand.blackjack?).to be false
			@hand.add(@c1, @c3)
			expect(@hand.blackjack?).to be true
		end

		it 'does not treat more than 2 cards as blackjack' do
			@hand.add(@c2, @c3, @c4)
			expect(@hand.blackjack?).to be false
		end

		it 'treats Ace as 1 when it would otherwise bust' do
			@hand.add(@c1, @c2)
			expect(@hand.points).to eq(14)
			@hand.add(@c3)
			expect(@hand.points).to eq(14)
		end
	end


	context '#split' do
		before(:each) do
			@hand = Hand.new
		end

		it 'permits splitting when first 2 cards are equal' do
			expect(@hand.can_split?).to be false
			@hand.add(@c5, @c6)
			expect(@hand.can_split?).to be true
		end

		it 'does not permit Aces to be split' do
			@hand.add(@c1, @c7)
			expect(@hand.can_split?).to be false
		end

		it 'does not permit unequal cards to be split' do
			@hand.add(@c3, @c6)
			expect(@hand.can_split?).to be false
		end

		it 'returns a new hand with one of the cards' do
			@hand.add(@c5, @c6)
			split_hand = @hand.split
			expect(@hand.cards.length).to eq(1)
			expect(split_hand.cards.length).to eq(1)
			expect([@c5, @c6]).to include(@hand.cards.first, split_hand.cards.first)
		end

		it 'raises an error when a hand cannot be split' do
			@hand.add(@c3, @c6)
			expect { @hand.split }.to raise_error
		end
	end
end