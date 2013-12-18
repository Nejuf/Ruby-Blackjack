class Player

	attr_accessor :name, :hands, :money, :active

	def initialize
		@name = "player"
		@hands = [Hand.new]
		@money = 1000
		@active = true
	end

	def choose_play(hand, dealer_points)
		raise NotImplementedError
	end

	def <=>(other_player)
		@money <=> other_player.money
	end
end