#!/usr/bin/env ruby
require './statcollector.rb'
require 'psych'


configuration = Psych.load_file('aim.yaml')
collector = StatCollector.new(StatConfiguration.new(configuration))

commits = collector.commits
puts commits


