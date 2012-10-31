require 'csv'
require 'json'

class CSVWriter
	def initialize()
	end

	def output(configuration,commits)
		title = ["date"] + configuration.collect.map{|key,command|key}
		stats = [title]
		commits.each { |commit| stats << 
			(commit.select{|key,entry|key != :hash}.map{|key,entry|entry})
		}
		stats.reverse.to_json
	end

	def output_to_csv(configuration,commits)
		stats = [head(commits)]
		commits.each { |commit| stats << 
			(commit.map{|key,entry|entry}).join(",")
		}
		stats
	end

	def head(commits)
		commits.first.map{|key,entry|"\"#{key}\""}.join(",")
	end
end
