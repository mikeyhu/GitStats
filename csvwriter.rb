require 'csv'
require 'json'

class CSVWriter
	def initialize()
	end

	def output(configuration,commits)
		title = ["date"] + configuration.collect.map{|key,command|key}
		stats = [title]
		commits.each { |commit| stats << 
			(commit.select{|key,entry|key !=  :hash}.map{|key,entry|entry})
		}
		stats.to_json
	end

	def output_to_csv(configuration,commits)
		title = (["date"] + configuration.collect.map{|key,command|key}).join(",")
		stats = [title]
		commits.each { |commit| stats << 
			(commit.select{|key,entry|key !=  :hash}.map{|key,entry|entry}).join(",")
		}
		stats
	end
end
