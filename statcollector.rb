require 'tmpdir'
require 'date'

class StatCollector

end

class StatConfiguration
	attr_accessor :max, :name, :location

	def initialize(configuration)
		@max = configuration["max"]
		@name = configuration["name"]
		@location = configuration["location"]
	end
end

