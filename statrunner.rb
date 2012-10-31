#!/usr/bin/env ruby
require './statcollector.rb'
require './jsonwriter.rb'
require 'psych'
require 'json'


yaml = Psych.load_file(ARGV[0])
configuration = StatConfiguration.new(yaml)
puts configuration.tmp_repo
collector = StatCollector.new(configuration)
statistics = collector.get_statistics

writer = JSONWriter.new()
output = writer.output(configuration,statistics)
puts output


