require('./src/Player')
require('./src/Prompter')

class HumanPlayer < Player
	include Prompter

	def initialize(taken_names)
		super()
		name = prompt("Please enter your name.") do |input|
			puts "input #{input}"
			(input.length > 0 && !taken_names.include?(input.downcase))
		end
	end
end