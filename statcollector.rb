require 'tmpdir'
require 'date'

class StatCollector
	attr_accessor :tmp_dir
	def initialize(configuration)
		@tmp_dir=Dir.mktmpdir + "/" + configuration.name
	end

end

class StatConfiguration
	attr_accessor :max, :name, :location, :collect

	def initialize(yaml)
		raise "Configuration must include a location" if yaml["location"].nil?
		@location = yaml["location"]
		@max = yaml["max"]||=0
		@name = yaml["name"]
		@collect = yaml["collect"]

	end
end

