require './statcollector.rb'
require 'psych'

describe "The StatConfiguration class" do
	before(:all) do
		@fullconfig = Psych.load('
name: myproject
location: /a/location/for/myproject
max: 10
collect:
 command1: "a command"
 command2: another command
')

		@partialconfig = Psych.load('
name: myproject
location: /a/location/for/myproject
collect:
 command1: "a command"
')

		@invalidconfig = Psych.load('
name: myproject
collect:
 command1: "a command"
')
	end

	it "should be able to be configured" do
		config = StatConfiguration.new(@fullconfig)
		config.max.should eq(10)
		config.name.should eq("myproject")
		config.location.should eq("/a/location/for/myproject")
	end

	it "should be able to be configured with sensible defaults" do
		config = StatConfiguration.new(@partialconfig)
		config.max.should eq(0)
		config.name.should eq("myproject")
		config.location.should eq("/a/location/for/myproject")
	end

	it "should not be able to be configured without a location" do
		expect { StatConfiguration.new(@invalidconfig) }.to raise_error
	end

	it "should have an hash of collection commands" do
		config = StatConfiguration.new(@fullconfig)
		config.collect.should eq "command1" => "a command","command2" => "another command"
	end
end

describe "The StatCollector class" do
	before(:all) do
		@fullconfig = Psych.load('
name: myproject
location: /a/location/for/myproject
max: 10
collect:
 command1: "a command"
 command2: another command
')
		@commits = 'ahash|2012-08-15|
bhash|2012-08-15|'
	end

	it "should create a temp directory when created" do
		collector = StatCollector.new(StatConfiguration.new(@fullconfig))
		collector.tmp_repo.should end_with("myproject")
		collector.tmp_repo.should start_with("/tmp")
		collector.tmp_repo.should start_with(collector.tmp_root)
	end

	it "should be able to retrieve a list of hashs containing commit information" do
		repo = double("book")
		repo.stub(:listCommits).and_return(@commits)
		collector = StatCollector.new(StatConfiguration.new(@fullconfig),repo)
		collector.commits.should eq([{:hash => "ahash",:date => "2012-08-15"},{:hash => "bhash",:date => "2012-08-15"}])
	end
end