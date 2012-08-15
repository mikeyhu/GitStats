require 'tmpdir'
require 'date'

class StatCollector

end

class StatConfiguration
	attr_accessor :max, :name, :location

	def initialize(configuration)
		raise "Configuration must include a location" if configuration["location"].nil?
		@location = configuration["location"]
		@max = configuration["max"]||=0
		@name = configuration["name"]
	end
end

