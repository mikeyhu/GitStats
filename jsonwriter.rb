require 'json'

class JSONWriter
	def initialize()
	end

	def save(configuration,commits)
		title = ["date"] + configuration.collect.map{|key,command|key}
		stats = [title]
		commits.each { |commit| stats << 
			(commit.select{|key,entry|key != :hash}.map{|key,entry|entry})
		}
		dataFile = File.new("#{configuration.tmp_root}/graphData.js", "w")
		dataFile.write("graphTitle=\"#{configuration.name}\"\n")
		dataFile.write("graphData=" + stats.to_json)
		dataFile.close
	end

	def copy_graph_to_output(configuration)
		`cp views/graph.html #{configuration.tmp_root}`
	end
end