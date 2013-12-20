require('./src/Game')

describe HumanPlayer do
	before(:each) do
		HumanPlayer.any_instance.stub(:puts)
	end

	context 'initialization' do
		before(:all) do
			HumanPlayer.any_instance.stub(:prompt) {'Bob'} #prompts for name in #initialize
			@player = HumanPlayer.new(['dealer', 'player'])
		end

		it 'should have a name other than the super default' do
			pl = Player.new
			expect(@player.name).to_not eq(pl.name)
		end
	end

	context '#choose_play' do
		before(:all) do
			HumanPlayer.any_instance.stub(:prompt) {'Bob'} #prompts for name in #initialize
			@player = HumanPlayer.new(['dealer', 'player'])
		end
		
		it 'prompts for a bet when hand.bet is 0' do
			@player.hands.first.bet = 0
			allow(@player).to receive(:prompt) { '44' }
			expect(@player.choose_play(@player.hands.first, 10)).to eq({ :action => :bet, :amount => 44 })
		end

		it 'converts the bet amount to an integer' do
			@player.hands.first.bet = 0
			allow(@player).to receive(:prompt) { '44.2929' }
			expect(@player.choose_play(@player.hands.first, 10)[:amount]).to eq(44)
		end

		it 'enables the player to quit' do
			allow(@player).to receive(:gets) { 'quit' }
			expect(@player.choose_play(@player.hands.first, 10)).to eq({ :action => :quit })
		end

		context 'after cards have been dealt' do
			before(:each) do
				@player = HumanPlayer.new(['dealer', 'player'])
				@player.hands.first.add(
						double('Card', :rank => 8, :suit => 'DIAMONDS', :show => true),
						double('Card', :rank => 8, :suit => 'CLUBS', :show => true)
					)
				@player.money = 1000
				@player.hands.first.bet = 10
			end

			it 'lets player hit' do
				allow(@player).to receive(:gets) { 'hit' }
				expect(@player.choose_play(@player.hands.first, 10)).to eq({ :action => :hit })
			end
			it 'lets player stay' do
				allow(@player).to receive(:gets) { 'stay' }
				expect(@player.choose_play(@player.hands.first, 10)).to eq({ :action => :stay })
			end
			it 'lets player double down' do
				allow(@player).to receive(:gets) { 'double down' }
				expect(@player.choose_play(@player.hands.first, 10)).to eq({ :action => :double_down })
			end
			it 'lets player split' do
				allow(@player).to receive(:gets) { 'split' }
				expect(@player.choose_play(@player.hands.first, 10)).to eq({ :action => :split })
			end
			it 'does not let player split when cards are not even' do
				@player.hands.first.cards[1] = double('Card', :rank => 9, :suit => 'DIAMONDS', :show => true)
				allow(@player).to receive(:prompt) { 'stay' }
				expect(@player).to receive(:prompt).with(kind_of(String), kind_of(String), ['hit', 'stay', 'double down', 'quit'])
				@player.choose_play(@player.hands.first, 10)
			end
		end
	end
end