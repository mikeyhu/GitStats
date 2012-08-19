#!/usr/bin/env ruby
require './statcollector.rb'
require './csvwriter.rb'
require 'psych'
require 'json'


yaml = Psych.load_file(ARGV[0])
configuration = StatConfiguration.new(yaml)
puts configuration.tmp_repo
collector = StatCollector.new(configuration)
statistics = collector.get_statistics

writer = CSVWriter.new()
output = writer.output_to_csv(configuration,statistics)
puts output


