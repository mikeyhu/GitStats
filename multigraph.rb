#!/usr/bin/env ruby
require './statcollector.rb'
require './jsonwriter.rb'
require './csvwriter.rb'
require 'psych'
require 'json'

configurations = ARGV.map {|yamlFile|
	yaml = Psych.load_file(yamlFile)
	StatConfiguration.new(yaml)
}

graphs = configurations.map {|configuration|
	collector = StatCollector.new(configuration)
	statistics = collector.get_statistics
	writer = JSONWriter.new()
	{
		:name => configuration.name,
		:statistics => writer.generate_array(configuration,statistics)
	}
}

data = "var graphs = #{graphs.to_json};"
html = graphs.map {|graph| "<div id=\"#{graph[:name]}\" style=\"float:left\"></div>"}.join("\n")

template = File.open("./template/multigraph.html").read
puts template.sub("$$DATA$$",data).sub("$$HTML$$",html)


