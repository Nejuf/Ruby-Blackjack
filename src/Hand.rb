require('./src/CardCollection')

class Hand
	include CardCollection
	
	def add(*args)
		args.each do |card|
			cards << card
		end
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
end