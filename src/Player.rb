class Player

	attr_accessor :name, :hands, :money

	def initialize
		@name = "player"
		@hands = [Hand.new]
		@money = 1000
	end
end