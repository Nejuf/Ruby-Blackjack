require('./Blackjack.rb')

describe HumanPlayer do

	context 'initialization' do
		before(:all) do
			@player = HumanPlayer.new
		end
	end
end