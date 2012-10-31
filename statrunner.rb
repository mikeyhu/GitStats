#!/usr/bin/env ruby
require './statcollector.rb'
require './jsonwriter.rb'
require './csvwriter.rb'
require 'psych'
require 'json'


yaml = Psych.load_file(ARGV[0])
configuration = StatConfiguration.new(yaml)
collector = StatCollector.new(configuration)
statistics = collector.get_statistics

case configuration.output
when "csv"
	writer = CSVWriter.new()
	puts writer.output(statistics)
when "json"
	puts statistics
when "array"
	writer = JSONWriter.new()
	puts writer.output(configuration,statistics)
else #graph
	writer = JSONWriter.new()
	output = writer.output(configuration,statistics)
	template = File.open("./template/googlegraph.html").read
	puts template.sub("$$DATA$$",output)
end


