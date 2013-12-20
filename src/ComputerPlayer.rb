require('./src/Player')

class ComputerPlayer < Player

	def initialize(name="computer")
		super()
		@name = name
	end

	def choose_play(hand, dealer_top_card=nil)
		if @money <= 0
			return { :action => :quit }
		end

		if hand.bet == 0
			bet = @money/5
			bet = bet <= 0 ? 1 : bet
			return { :action => :bet, :amount => bet }
		else
			if hand.can_split?
				if hand.points == 16 || hand.points == 14
					return { :action => :split }
				end
			end

			if dealer_top_card.rank == 1 || dealer_top_card.rank > 9
				if hand.points < 17
					return { :action => :hit }
				else
					return { :action => :stay }
				end
			else
				if hand.points < 12
					if hand.points < 10
						return { :action => :hit }
					else
						return { :action => :double_down }
					end
				else
					return { :action => :stay }
				end
			end
		end
	end
end