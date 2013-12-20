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
		# Create card double variables (@c1s == ace of spades, @c11d = jack of diamonds)
		SUITS = %w( CLUBS DIAMONDS HEARTS SPADES )
		SUITS.each do |suit|
			13.times do |num|
				instance_variable_set( "@c#{num + 1}#{suit.slice(0,1).downcase}", double('Card', :rank => num + 1, :suit => suit, :show => true))
			end
		end
	end

	context '#add' do
		before(:all) do
			@hand = Hand.new
		end

		it 'adds a card' do
			@hand = Hand.new
			@hand.add(@c1d)
			expect(@hand.cards.length).to eq(1)
		end

		it 'adds multiple cards' do
			@hand = Hand.new
			@hand.add(@c3h, @c13c)
			expect(@hand.cards.length).to eq(2)
		end
	end

	context '#points' do
		before(:each) do
			@hand = Hand.new
		end

		it 'considers face cards 10 points' do
			@hand.add(@c3h, @c13c)
			expect(@hand.points).to eq(13)
		end

		it 'identifies bust' do
			@hand.add(@c13c, @c5s)
			expect(@hand.bust?).to be false
			@hand.add(@c8s)
			expect(@hand.bust?).to be true
		end

		it 'identifies blackjack' do
			expect(@hand.blackjack?).to be false
			@hand.add(@c1d, @c13c)
			expect(@hand.blackjack?).to be true
		end

		it 'does not treat more than 2 cards as blackjack' do
			@hand.add(@c3h, @c13c, @c8s)
			expect(@hand.blackjack?).to be false
		end

		it 'treats Ace as 1 when it would otherwise bust' do
			@hand.add(@c1d, @c3h)
			expect(@hand.points).to eq(14)
			@hand.add(@c13c)
			expect(@hand.points).to eq(14)
		end
	end


	context '#split' do
		before(:each) do
			@hand = Hand.new
		end

		it 'permits splitting when first 2 cards are equal' do
			expect(@hand.can_split?).to be false
			@hand.add(@c5s, @c5d)
			expect(@hand.can_split?).to be true
		end

		it 'does not permit Aces to be split' do
			@hand.add(@c1d, @c1c)
			expect(@hand.can_split?).to be false
		end

		it 'does not permit unequal cards to be split' do
			@hand.add(@c13c, @c5d)
			expect(@hand.can_split?).to be false
		end

		it 'returns a new hand with one of the cards' do
			@hand.add(@c5s, @c5d)
			split_hand = @hand.split
			expect(@hand.cards.length).to eq(1)
			expect(split_hand.cards.length).to eq(1)
			expect([@c5s, @c5d]).to include(@hand.cards.first, split_hand.cards.first)
		end

		it 'raises an error when a hand cannot be split' do
			@hand.add(@c13c, @c5d)
			expect { @hand.split }.to raise_error
		end
	end

	context '#<=>' do
		before(:each) do
			@hand = Hand.new
			@other_hand = Hand.new
		end
		it 'returns 0 for two normal equal hands' do
			@hand.add(@c11d, @c3d, @c3h)
			@other_hand.add(@c6s, @c13h)
			expect(@hand<=>@other_hand).to eq(0)
		end

		it 'returns 1 when other hand is less' do
			@hand.add(@c7d, @c2h)
			@other_hand.add(@c4h, @c3h)
			expect(@hand<=>@other_hand).to eq(1)
		end

		it 'returns -1 when other hand is greater' do
			@hand.add(@c7d, @c3h)
			@other_hand.add(@c7h, @c6h)
			expect(@hand<=>@other_hand).to eq(-1)
		end

		it 'always returns 1 when hand has blackjack' do
			@hand.add(@c1d, @c12h)
			@other_hand.add(@c10h, @c1c)
			expect(@hand<=>@other_hand).to eq(1)
		end

		it 'returns 0 when both hands are bust' do 
			@hand.add(@c1d, @c12h, @c7h, @c7d)
			@other_hand.add(@c10h, @c4h, @c8d)
			expect(@hand<=>@other_hand).to eq(0)
		end

		it 'returns -1 when bust and other hand is not' do
			@hand.add(@c11d, @c2d, @c12h)
			@other_hand.add(@c2h, @c3h, @c4d)
			expect(@hand<=>@other_hand).to eq(-1)
		end
	end
end