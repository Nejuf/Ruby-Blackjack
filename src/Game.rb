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
		while active_human_player?

			#--Player Turns--
			while active_hand?

				@players.each do |player|
					i = 0
					while i < player.hands.length
						i += 1
						hand = player.hands[i]

						if(hand.bet > 0 && hand.cards.length == 0)
							hand.add(@deck.draw)
						elsif(hand.cards.length == 1)
							card = @deck.draw
							card.show
							hand.add(card)
						else
							hand.active = true
							while hand.active
								action = player.choose_play(hand, @dealer_hand.points)

								case action[:action]
								when :bet
									hand.bet += action[:amount]
								when :hit
									new_card = @deck.draw
									new_card.show
									hand.add(new_card)
								when :stay
									hand.active = false
								when :double_down
									hand.bet += hand.bet
									new_card = @deck.draw
									new_card.show
									hand.add(new_card)
									hand.active = false
								when :split
									new_hand = hand.split
									player.hands.insert(i+1, new_hand)
								when :quit
									player.hands.each do |h|
										hand.active = false
										player.money -= h.bet
									end
									player.active = false
								else
									raise "Unrecognized player action: #{action}"
								end
							end
						end
					end
				end
			end

			#--Dealer's Turn

			#--Wins and Losses
		end

		notify('Game Over!')
		notify('Final totals:')
		@players.sort.each do |player|
			notify("--#{player.name}: $#{@player.money}")
		end
	end

	def active_hand?
		@players.each do |player|
			player.hands.each do |hand|
				return true if hand.active
			end
		end
		false
	end

	def active_human_player?
		@players.each do |player|
			if player.is_a?(HumanPlayer) && player.active
				return true
			end
		end
		false
	end
end