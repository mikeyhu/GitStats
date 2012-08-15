require './statcollector.rb'
require 'psych'

describe "The collector" do
	before(:all) do
		@testConfig = Psych.load('
name: myproject
location: /a/location/for/myproject
max: 10
collect:
 command1: "a command"
 command2: "another command"
')
	end

	it "should be able to be configured" do
		puts @testConfig["name"]
		config = StatConfiguration.new(@testConfig)
		config.max.should eq(10)
		config.name.should eq("myproject")
		config.location.should eq("/a/location/for/myproject")
	end
end