require 'json'

class JSONWriter
	def initialize()
	end

	def output_json(configuration,commits)
		commits.to_json
	end

	def output_array(configuration,commits)
		title = ["date"] + configuration.collect.map{|key,command|key}
		stats = [title]
		commits.each { |commit| stats <<
			(commit.select{|key,entry|key != :hash}.map{|key,entry|entry})
		}
		stats.to_json
	end
end
