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
			@deck.shuffle

			#--Set dealer's cards
			@dealer_hand.add(*@deck.draw(2))

			#-- Get Bets
			@players.each do |player|
				next unless player.active

				action = player.choose_play(player.hands.first, @dealer_hand.cards.last)

				case action[:action]
				when :bet
					player.hands.first.bet += action[:amount]
				when :quit
					player.hands.each do |hand|
						hand.active = false
						player.money -= hand.bet
					end
					player.active = false
				else
					raise "Can only bet or quit at this stage.\nUnrecognized player action: #{action}"
				end
			end

			#--Player Turns--
			while active_hand?

				@players.each do |player|
					next unless player.active

					i = 0
					while i < player.hands.length
						hand = player.hands[i]
						i += 1

						if(hand.bet > 0 && hand.cards.length == 0)
							hand.add(@deck.draw.first)
						elsif(hand.cards.length == 1)
							hit(hand)
						else
							hand.active = true
							while hand.active
								display_table(hand)
								action = player.choose_play(hand, @dealer_hand.cards.last)

								case action[:action]
								when :bet
									raise 'Cannot bet at this stage.'
								when :hit
									hit(hand)
								when :stay
									hand.active = false
								when :double_down
									hand.bet += hand.bet
									hit(hand)
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

			display_table(nil, true)

			#--Dealer's Turn
			@dealer_hand.cards.first.show
			while(@dealer_hand.points < 17)
				hit(@dealer_hand)
			end
			display_table(nil, true)

			#--Wins and Losses
			@players.each do |player|
				player.hands.each do |hand|
					case hand <=> @dealer_hand
					when -1
						player.money -= hand.bet
						notify "--#{player.name} loses $#{hand.bet}."
					when 0
						notify "--#{player.name} pushed."
					when 1
						if hand.blackjack?
							winnings = (hand.bet * 1.5).floor
							player.money += winnings
							notify "--Blackjack! #{player.name} wins $#{winnings}."

						else
							player.money += hand.bet
							notify "--#{player.name} wins $#{hand.bet}."
						end
					end
				end
			end

			#--Reset table
			@deck = Deck.new
			@dealer_hand = Hand.new

			@players.each do |player|
				player.hands = player.active ? [Hand.new] : []
			end
		end

		notify('Game Over!')
		notify('Final totals:')
		@players.sort.reverse.each do |player|
			notify "--#{player.name}: $#{player.money}"
		end
	end

	def hit(hand)
		new_card = @deck.draw.first
		new_card.show
		hand.add(new_card)
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
			if player.active && player.is_a?(HumanPlayer)
				return true
			end
		end
		false
	end

	def display_table(hand_to_show=nil, show_all_hands=false)
		puts 'Ruby Blackjack!'.center(80, '-')
		puts border_center
		puts border_center('Dealer')
		if show_all_hands || (hand_to_show == @dealer_hand)
			puts border_center(@dealer_hand.to_show)
		else
			puts border_center(@dealer_hand.to_s)
		end
		puts border_center
		hand_strings = []
		player_strings = []
		bet_strings = []
		money_strings = []
		@players.each do |player|
			if !player.active
					hand_string_len = player.name.length + 2
					hand_strings << " " * hand_string_len
					player_strings << player.name.center(hand_string_len)
					bet_strings << "$--".center(hand_string_len)
					money_strings << "$#{player.money}".center(hand_string_len)
			else
				player.hands.each do |hand|
					if show_all_hands || (hand_to_show == hand)
						hand_strings << hand.to_show
					else
						hand_strings << hand.to_s
					end
					hand_string_len = hand_strings.last.length
					player_strings << player.name.slice(0,hand_string_len).center(hand_string_len)
					bet_strings << "$#{hand.bet}".center(hand_string_len)
					money_strings << "$#{player.money}".center(hand_string_len)
				end
			end
		end
		puts border_center(hand_strings.join(' | '))
		puts border_center(bet_strings.join(' | '))
		puts border_center(player_strings.join(' | '))
		puts border_center(money_strings.join(' | '))
		puts border_center
	end

	def border_center(str=' ', width=80)
		line = str.center(width)
		line[0] = '*'
		line[line.length-1] = '*'
		line
	end
end