class Player

	attr_accessor :name, :hands, :money

	def initialize
		@name = "player"
		@hands = [Hand.new]
		@money = 1000
		@active = true
	end

	def active
		@active = false if @money < 0
		@active
	end

	def active=(bool)
		return if bool && (@money < 0)
		@active = bool
	end

	def choose_play(hand, dealer_points)
		raise NotImplementedError
	end

	def total_bets
		total = 0
		hands.inject(total) do |total, hand|
			total + hand.bet
		end
	end

	def <=>(other_player)
		@money <=> other_player.money
	end
end