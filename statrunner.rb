#!/usr/bin/env ruby
require './statcollector.rb'
require 'psych'


yaml = Psych.load_file('project-eular-scala.yaml')
configuration = StatConfiguration.new(yaml)
puts configuration.tmp_repo
collector = StatCollector.new(configuration)
puts collector.get_statistics

