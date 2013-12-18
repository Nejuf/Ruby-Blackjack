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
			#--Set dealer's cards
			@dealer_hand.add(*@deck.draw(2))

			#-- Get Bets
			@players.each do |player|
				action = player.choose_play(player.hands.first, @dealer_hand.points)

				case action[:action]
				when :bet
					player.hands.first.bet += action[:amount]
				when :quit
					player.hands.each do |h|
						hand.active = false
						player.money -= h.bet
					end
					player.active = false
				else
					raise "Can only bet or quit at this stage.\nUnrecognized player action: #{action}"
				end
			end

			#--Player Turns--
			while active_hand?

				@players.each do |player|
					i = 0
					while i < player.hands.length
						hand = player.hands[i]
						i += 1

						if(hand.bet > 0 && hand.cards.length == 0)
							hand.add(@deck.draw.first)
						elsif(hand.cards.length == 1)
							card = @deck.draw.first
							card.show
							hand.add(card)
						else
							hand.active = true
							while hand.active
								display_table
								action = player.choose_play(hand, @dealer_hand.points)

								case action[:action]
								when :bet
									raise 'Cannot bet at this stage.'
								when :hit
									new_card = @deck.draw.first
									new_card.show
									hand.add(new_card)
								when :stay
									hand.active = false
								when :double_down
									hand.bet += hand.bet
									new_card = @deck.draw.first
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

	def display_table
		puts 'Ruby Blackjack!'.center(80, '-')
		puts border_center
		puts border_center(@dealer_hand.to_s)
		puts border_center
		hand_strings = []
		player_strings = []
		@players.each do |player|
			player.hands.each do |hand|
				hand_strings << hand.to_s
				player_strings << player.name.center(hand_strings.last.length)
			end
		end
		puts border_center(hand_strings.join(' | '))
		puts border_center(player_strings.join(' '))
		puts border_center
	end

	def border_center(str=' ', width=80)
		line = str.center(width)
		line[0] = '*'
		line[line.length-1] = '*'
		line
	end
end