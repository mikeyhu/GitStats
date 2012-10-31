require 'json'

class JSONWriter
	def initialize()
	end

	def output(configuration,commits)
		title = ["date"] + configuration.collect.map{|key,command|key}
		stats = [title]
		if(configuration.decending)
			rows = commits
		else
			rows = commits.reverse
		end
		rows.each { |commit| stats << 
			(commit.select{|key,entry|key != :hash}.map{|key,entry|entry})
		}
		stats.to_json
	end
end
