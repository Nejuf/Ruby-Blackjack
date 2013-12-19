require('./src/CardCollection')

class Hand
	include CardCollection
	
	attr_accessor :bet, :active

	def initialize
		@bet = 0
		@active = true
	end

	def add(*args)
		args.each do |card|
			card.show if(cards.length > 0)
			cards << card
		end

		@active = false if bust?
	end

	def points
		total = 0
		aces = 0

		cards.each do |card|
			if card.rank == 1
				aces += 1
			elsif card.rank > 10
				total += 10
			else
				total += card.rank
			end
		end

		while aces > 0 do
			aces -= 1

			if (total + 11 + aces) > 21
				total += 1
			else
				total += 11
			end
		end

		total
	end

	def bust?
		points > 21
	end

	def blackjack?
		return false if cards.length != 2
		points == 21
	end

	def can_split?
		return false if cards.length != 2
		return false if cards.first.rank == 1
		return false if cards.first.rank != cards.last.rank
		true
	end

	def split
		raise Error, 'This hand cannot be split.' unless can_split?

		new_hand = Hand.new
		new_hand.bet = @bet
		new_hand.add(cards.pop)
		new_hand
	end

	def to_s
		str = ""
		cards.each do |c|
			if c.is_down?
				str << " ??"
			else
				str << " #{c}"
			end
		end
		str
	end

	def to_show
		str = ""
		cards.each do |c|
			str << " #{c}"
		end
		str
	end

	def <=>(other_hand)
		return 1 if blackjack?
		return 0 if bust? && other_hand.bust?
		return -1 if bust?
		return 1 if other_hand.bust?
		points <=> other_hand.points
	end
end