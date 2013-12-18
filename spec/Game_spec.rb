require('./Blackjack.rb')

describe Game do

	context "initialization" do
		before(:all) do
			@game = Game.new
		end

		it "with a 52 card deck" do
			expect(@game.deck.length).to eq(52) 
		end

	end

end