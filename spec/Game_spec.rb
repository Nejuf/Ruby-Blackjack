require('./Blackjack.rb')

describe Game do

	before(:each) do
		HumanPlayer.any_instance.stub(:puts)
		Game.any_instance.stub(:puts)
		HumanPlayer.any_instance.stub(:prompt) {'stub'}
		Game.any_instance.stub(:prompt) {'stub'}
	end

	context '#initialize' do
		before(:all) do
			@game = Game.new
		end

		it 'creates a list of reserved names' do
			expect(@game.taken_names.length).to be > 0
		end

		it 'creates a deck' do
			expect(@game.deck).to_not be_nil
		end

		it 'creates an empty array of players' do
			expect(@game.players.length).to eq(0)
		end

		it 'creates the dealer hand' do
			expect(@game.dealer_hand).to_not be_nil
		end
	end

	context '#start' do
		before(:all) do
			@game = Game.new
			@game.stub(:prompt) { '1' } #number of players
			@game.stub(:game_loop)
			HumanPlayer.any_instance.stub(:prompt){ 'Bob' } unless HumanPlayer.nil?
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

	context 'after game setup, but not started' do
		before(:all) do
			HumanPlayer.any_instance.stub(:puts)
			@game = Game.new
			@game.players = [
				HumanPlayer.new(['player', 'dealer']),
				HumanPlayer.new(['player', 'dealer']),
				ComputerPlayer.new('comp1'),
				ComputerPlayer.new('comp2')
			]
			@game.players.each do |player|
				player.hands.each do |hand|
					hand.add(*@game.deck.draw(2))
				end
			end
		end

		context '#hit' do
			it 'adds a new card to a hand' do
				hand = @game.players.first.hands.first
				hand_len = hand.cards.length
				@game.hit(hand)
				expect(hand.cards.length).to eq(hand_len + 1)
			end
		end

		context '#active_hand?' do
			it 'returns false if no hands are active among all the players' do
				@game.players.each do |player|
					player.hands.each do |hand|
						hand.active = false
					end
				end
				expect(@game.active_hand?).to be false
			end

			it 'returns true if just one hand is active among all players' do
				@game.players.each do |player|
					player.hands.each do |hand|
						hand.active = false
					end
				end
				@game.players.first.hands.first.active = true

				expect(@game.active_hand?).to be true
			end
		end

		context '#active_human_player?' do
			it 'returns false if only computer players are active' do
				@game.players.each do |player|
					player.active = player.is_a?(HumanPlayer) ? false : true
				end
				expect(@game.active_human_player?).to be false
			end

			it 'returns true if one human player is active' do
				human = nil
				@game.players.each do |player|
					human = player if player.is_a?(HumanPlayer)
					player.active = false
				end
				human.active = true
				expect(@game.active_human_player?).to be true
			end
		end

		context 'turns' do
			before(:all) do
				@game.players = [
					ComputerPlayer.new('comp1'),
					ComputerPlayer.new('comp2'),
					ComputerPlayer.new('comp3'),
					ComputerPlayer.new('comp4')
				]
			end

			context '#get_player_bets' do
				it 'gets bets from all players' do
					@game.get_player_bets

					@game.players.each do |player|
						player.hands.each do |hand|
							expect(hand.bet).to be > 0
						end
					end
				end
			end

			context '#take_player_turns' do
				it 'does not leave active hands' do
					@game.dealer_hand.add(*@game.deck.draw(2))
					@game.take_player_turns
					@game.players.each do |player|
						player.hands.each do |hand|
							expect(hand.active).to be false
						end
					end
				end
			end

			context '#take_dealer_turn' do

			end
		end
	end
end