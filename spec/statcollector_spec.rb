require './statcollector.rb'
require 'psych'

describe "The StatConfiguration class" do
	before(:all) do
		@fullconfig = Psych.load('
name: myproject
location: /a/location/for/myproject
max: 10
one_per_day: true
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
		config.one_per_day.should eq(true)
	end

	it "should be able to be configured with sensible defaults" do
		config = StatConfiguration.new(@partialconfig)
		config.max.should eq(0)
		config.name.should eq("myproject")
		config.location.should eq("/a/location/for/myproject")
		config.one_per_day.should eq(false)
	end

	it "should not be able to be configured without a location" do
		expect { StatConfiguration.new(@invalidconfig) }.to raise_error
	end

	it "should have an hash of collection commands" do
		config = StatConfiguration.new(@fullconfig)
		config.collect.should eq "command1" => "a command","command2" => "another command"
	end

	it "should setup a temp directory when created" do
		config = StatConfiguration.new(@fullconfig)
		config.tmp_repo.should end_with("myproject")
		config.tmp_repo.should start_with(config.tmp_root)
	end
end

describe "The StatCollector class" do
	before(:all) do
		@fullconfig = Psych.load('
name: myproject
location: /a/location/for/myproject
max: 0
collect:
 command1: "a command"
 command2: another command
')
		@commits = 'ahash|2012-08-15|
bhash|2012-08-15|
chash|2012-08-14|'
	end

	before(:each) do
		@repo = double("GitRunner")
		@repo.stub(:listCommits).and_return(@commits)
		@repo.stub(:setupRepo)
		@repo.stub(:checkout)

		@config = double("StatConfiguration")
		@config.stub(:location).and_return("/location")
		@config.stub(:collect).and_return({"command1" => "a command","command2" => "another command"})
	end

	it "should be able to retrieve a list of hashs containing commit information" do
		collector = StatCollector.new(StatConfiguration.new(@fullconfig),@repo)
		collector.commits.should eq([{:hash => "ahash",:date => "2012-08-15"},{:hash => "bhash",:date => "2012-08-15"},{:hash => "chash",:date => "2012-08-14"}])
	end

	it "should be able to collect information on each commit" do
		@repo.stub(:runCmd).and_return("1","2")
		collector = StatCollector.new(StatConfiguration.new(@fullconfig),@repo)
		collector.checkout_and_collect({:hash => "ahash", :date => "2012-08-15"}).should eq({:hash => "ahash", :date => "2012-08-15", "command1" => 1, "command2" => 2})
	end

	it "should be able to collect information on a number of commits" do
		@repo.stub(:runCmd).and_return("1","2","3","4","5","6")
		@config.stub(:max).and_return(0) #0 means that we should return an unlimited number of results
		@config.stub(:one_per_day).and_return(false)
		collector = StatCollector.new(@config,@repo)
		statistics = collector.get_statistics
		statistics.first.should eq({:hash => "ahash", :date => "2012-08-15", "command1" => 1, "command2" => 2})
		statistics.last.should eq({:hash => "chash", :date => "2012-08-14", "command1" => 5, "command2" => 6})

		statistics.size.should eq(3) 
	end

	it "should be able to limit collecting to the value of max" do
		@repo.stub(:runCmd).and_return("1","2","3","4","5","6")
		@config.stub(:max).and_return(1)
		@config.stub(:one_per_day).and_return(false)
		collector = StatCollector.new(@config,@repo)
		statistics = collector.get_statistics
		#statistics[0].should eq({:hash => "ahash", :date => "2012-08-15", "command1" => 1, "command2" => 2})
		statistics.size.should eq(1)
	end

	it "should be able to collect information on a maximum of 1 commit a day" do
		@repo.stub(:runCmd).and_return("1","2","3","4")
		@config.stub(:max).and_return(0) #0 means that we should return an unlimited number of results
		@config.stub(:one_per_day).and_return(true)
		collector = StatCollector.new(@config,@repo)
		statistics = collector.get_statistics
		statistics.size.should eq(2)
		statistics[0].should eq({:hash => "ahash", :date => "2012-08-15", "command1" => 1, "command2" => 2})
		statistics[1].should eq({:hash => "chash", :date => "2012-08-14", "command1" => 3, "command2" => 4})
		 
	end
end