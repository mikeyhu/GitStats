#!/usr/bin/env ruby
require './statcollector.rb'
require './csvwriter.rb'
require './jsonwriter.rb'
require 'psych'


yaml = Psych.load_file(ARGV[0])
configuration = StatConfiguration.new(yaml)

collector = StatCollector.new(configuration)
statistics = collector.get_statistics

#writer = CSVWriter.new()
#output = writer.output_to_csv(configuration,statistics)
#puts output

writer = JSONWriter.new()
writer.save(configuration,statistics.reverse)
writer.copy_graph_to_output(configuration)
puts configuration.tmp_root + "/graph.html"
