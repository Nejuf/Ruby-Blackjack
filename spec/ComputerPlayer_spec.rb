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
end