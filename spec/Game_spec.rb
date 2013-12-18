require('./Blackjack.rb')

describe Game do

	context 'start' do
		before(:all) do
			@game = Game.new
			@game.stub(:gets) { '1' } #number of players
			@game.stub(:game_loop)
			HumanPlayer.any_instance.stub(:gets){ 'Bob' } unless HumanPlayer.nil?
			@game.start
		end

		it 'with a 52 card deck' do
			expect(@game.deck.length).to eq(52) 
		end

		it 'has 4 players' do
			expect(@game.players.length).to eq(4)
		end

		it 'has an empty dealer hand' do
			expect(@game.dealer_hand.cards).to be_empty
		end

	end

end