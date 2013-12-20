require('./src/Game')

describe Player do

	context 'initialization' do
		before(:all) do
			@player = Player.new
		end

		it 'has a default name' do
			expect(@player.name.length).to be > 0
		end

		it 'has $1000' do
			expect(@player.money).to eq(1000)
		end

		it 'has 1 hand' do
			expect(@player.hands.length).to eq(1)
		end

		it 'has the player active' do
			expect(@player.active).to be true
		end
	end

	context '#active' do
		it 'automatically returns false if money is 0' do
			@player = Player.new
			expect(@player.active).to be true
			@player.money = 0
			expect(@player.active).to be false
		end
	end

	context '#total_bets' do
		it 'adds bets from all hands' do
			@player = Player.new
			@player.hands << double('Hand', :bet => 20)
			@player.hands << double('Hand', :bet => 40)
			@player.hands << double('Hand', :bet => 60)
			expect(@player.total_bets).to eq(120)
		end
	end

	context '#choose_play' do
		it 'raises NotImplementedError' do
			@player = Player.new
			expect{ @player.choose_play(double('Hand'), 10) }.to raise_error NotImplementedError
		end
	end
end