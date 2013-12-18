module Prompter
	def prompt(message, fail_message="Invalid input.", options=[], &proc)
		puts message
		return gets.chomp if options.empty? && proc.nil?

		response = ""
		while response.empty?
			input = gets.chomp
			if(options.include?(input))
				response = input
			elsif proc && proc.call(input)
				response = input
			else
				puts fail_message
			end
		end

		response
	end

	def notify(message)
		puts message
	end
end