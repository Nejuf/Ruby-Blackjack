require('./src/Player')
require('./src/Prompter')

class HumanPlayer < Player
	include Prompter

	def initialize(taken_names)
		super()
		@name = prompt("Please enter your name.") do |input|
			(input.length > 0 && !taken_names.include?(input.downcase))
		end
	end

	def choose_play(hand, dealer_points)
		if hand.bet == 0
			bet = prompt("#{@name}, How much will you bet? ($1-$#{@money}) or (\"quit\" to stop playing)", "Invalid bet.") do |input|
				return { :action => :quit } if input.downcase == 'quit'
				(input.to_i >= 1 && input.to_i <= @money)
			end
			bet = bet.to_i
			return { :action => :bet, :amount => bet }
		else
			options = ['hit', 'stay']
			if @money >= (hand.bet + total_bets)
				options << 'split' if hand.can_split?
				options << 'double down' 
			end
			options << 'quit'

			choice = prompt("#{@name}, What will you do? (#{options.join(', ')})", "Invalid choice.", options)
			choice = choice.sub(' ', '_').downcase
			return {:action => choice.to_sym }
		end
	end
end