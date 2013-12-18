require('./src/Player')

class ComputerPlayer < Player

	def initialize(name="computer")
		super()
		@name = name
	end
end