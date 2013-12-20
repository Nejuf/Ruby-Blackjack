require('./Blackjack.rb')

describe ComputerPlayer do

	context 'initialization' do
		before(:all) do
			@player = ComputerPlayer.new
		end

		it 'should take a name as a parameter' do
			cp = ComputerPlayer.new('somename')
			expect(cp.name).to eq('somename')
		end
	end

	context '#choose_play' do
		before(:each) do
			@player = ComputerPlayer.new
			@player.hands.first.bet = 200
			# Create card double variables (@c1s == ace of spades, @c11d = jack of diamonds)
			suits = %w( CLUBS DIAMONDS HEARTS SPADES )
			suits.each do |suit|
				13.times do |num|
					instance_variable_set( "@c#{num + 1}#{suit.slice(0,1).downcase}", 
						double('Card', :rank => num + 1, :suit => suit, :show => true))
				end
			end
		end
	
		context 'betting' do
			before(:each) do
				@player.money = 1000
				@player.hands.first.bet = 0
			end

			it 'bets a fifth of total money' do
				expect(@player.choose_play(@player.hands.first, @c10h)).to eq({ :action => :bet, :amount => 200})
			end

			it 'quits when out of money' do
				@player.money = 0
				expect(@player.choose_play(@player.hands.first, @c10h)).to eq({ :action => :quit })
			end
		end
		it 'splits when dealt a pair of sevens' do
			@player.hands.first.add(@c7h, @c7d)
			expect(@player.choose_play(@player.hands.first, @c10h)).to eq({ :action => :split })
		end
		it 'splits when dealt a pair of eights' do
			@player.hands.first.add(@c8h, @c8d)
			expect(@player.choose_play(@player.hands.first, @c10h)).to eq({ :action => :split })
		end

		context 'non-split hand, and dealer top card is 2-9' do
			it 'double downs when player points are 10-11' do
				@player.hands.first.add(@c5h, @c5d)
				expect(@player.choose_play(@player.hands.first, @c6h)).to eq({ :action => :double_down })
			end

			it 'hits when points less than 10' do
				@player.hands.first.add(@c5h, @c4d)
				expect(@player.choose_play(@player.hands.first, @c6h)).to eq({ :action => :hit })
			end

			it 'stays when points greater than 11' do
				@player.hands.first.add(@c6h, @c8d)
				expect(@player.choose_play(@player.hands.first, @c6h)).to eq({ :action => :stay })
			end
		end

		context 'non-split hand, and dealer top card is Ace or 10/Face' do
			it 'does not double downs when player points are 10-11' do
				@player.hands.first.add(@c5h, @c5d)
				expect(@player.choose_play(@player.hands.first, @c10h)[:action]).to_not eq(:double_down)
			end

			it 'hits when points less than 17' do
				@player.hands.first.add(@c6h, @c10d)
				expect(@player.choose_play(@player.hands.first, @c10h)).to eq({ :action => :hit })
			end

			it 'stays when points greater than 16' do
				@player.hands.first.add(@c9h, @c8d)
				expect(@player.choose_play(@player.hands.first, @c10h)).to eq({ :action => :stay })
			end
		end
	end
end