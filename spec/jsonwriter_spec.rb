require './jsonwriter.rb'

describe "The JSONWriter class" do
	before(:each) do
		@config = double("StatConfiguration")
		@config.stub(:collect).and_return({"command1" => "a command","command2" => "another command"})
		@data = [{:hash => "ahash", :date => "2012-08-15", "command1" => 1, "command2" => 2},{:hash => "bhash", :date => "2012-08-16", "command1" => 3, "command2" => 4}]
	end

	it "should be able to output an json array" do
		writer = JSONWriter.new()
		writer.output_json(@config,@data).should eq('[{"hash":"ahash","date":"2012-08-15","command1":1,"command2":2},{"hash":"bhash","date":"2012-08-16","command1":3,"command2":4}]')
	end

	it "should be able to output an json object" do
		writer = JSONWriter.new()
		writer.output_array(@config,@data).should eq('[["date","command1","command2"],["2012-08-15",1,2],["2012-08-16",3,4]]')
	end
end
