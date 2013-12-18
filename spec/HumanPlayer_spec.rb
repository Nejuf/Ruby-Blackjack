require('./Blackjack.rb')

describe HumanPlayer do

	context 'initialization' do
		before(:all) do
			HumanPlayer.any_instance.stub(:gets) {'Bob'}
			@player = HumanPlayer.new(['dealer', 'player'])
		end

		it 'should have a name other than the default' do
			pl = Player.new
			expect(@player.name).to_not eq(pl.name)
		end
	end
end