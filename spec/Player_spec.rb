require('./Blackjack.rb')

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

	end
end