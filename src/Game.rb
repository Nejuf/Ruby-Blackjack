require('./src/Deck')
require('./src/Hand')
require('./src/HumanPlayer')
require('./src/ComputerPlayer')
require('./src/Prompter')

class Game
	include Prompter

	attr_accessor :deck, :players
	attr_reader :dealer_hand

	def start
		taken_names = %w( player dealer comp1 comp2 comp3 )

		@deck = Deck.new
		@players = []
		@dealer_hand = Hand.new

		human_count = prompt('How many human players? (1-4)', 'Invalid input.', %w( 1 2 3 4 )).to_i
		human_count.times do 
			@players << HumanPlayer.new(taken_names)
			taken_names << @players.last.name
		end

		(4-@players.length).times do |num|
			@players << ComputerPlayer.new("comp#{num}")
		end

		game_loop
	end

	def game_loop

		while human_player_active
			human_player_active = false
			@players.each do |player|
				player.hands.each do |hand|
					if(hand.cards.length == 0)
						hand.add(@deck.draw)
					elsif(hand.cards.length == 1)
						card = @deck.draw
						card.show
						hand.add(card)
					else
						player_turn = true
						while player_turn
							action = player.choose_play(@dealer_hand.points)

							case action
							when :bet

							when :hit
								new_card = @deck.draw
								new_card.show
								player.hand.add(new_card)
							when :stay
								player_turn = false
							when :double_down
							when :split
							when :quit
							else
								raise "Unrecognized player action: #{action}"
							end
						end
					end
				end

				if player.is_a?(HumanPlayer) && player.in_game?
					human_player_active = true 
				end
			end
		end

		notify('Game Over!')
		notify('Final totals:')
		@players.each do |player|
			notify("--#{player.name}: $#{@player.money}")
		end
	end
end