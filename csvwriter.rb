require 'csv'
require 'json'

class CSVWriter
	def initialize()
	end

	def output(commits)
		stats = [head(commits)]
		commits.each { |commit| stats << 
			commit.map{|key,entry|"\"#{entry}\""}.join(",")
		}
		stats.join("\n")
	end

	def head(commits)
		commits.first.map{|key,entry|"\"#{key}\""}.join(",")
	end
end
