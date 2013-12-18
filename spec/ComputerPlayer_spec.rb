require('./Blackjack.rb')

describe ComputerPlayer do

	context 'initialization' do
		before(:all) do
			@player = ComputerPlayer.new
		end
	end
end