require('./src/CardCollection')

class Hand
	include CardCollection
	
	def add(*args)
		args.each do |card|
			cards << card
		end
	end
end