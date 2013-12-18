require('./Blackjack.rb')

describe Game do

	context 'start' do
		before(:all) do
			@game = Game.new
			@game.stub(:gets) { '1' } #number of players
			@game.start
		end

		it 'with a 52 card deck' do
			expect(@game.deck.length).to eq(52) 
		end

	end

end