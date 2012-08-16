#!/usr/bin/env ruby
require './statcollector.rb'
require 'psych'


yaml = Psych.load_file('aim.yaml')
configuration = StatConfiguration.new(yaml)
puts configuration.tmp_repo
collector = StatCollector.new(configuration)
commits = collector.commits
puts collector.checkout_and_collect(commits[0])

