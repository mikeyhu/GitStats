require './csvwriter.rb'

describe "The CSVWriter class" do
	it "should be able to write a header row" do
		writer = CSVWriter.new()
		data = [{:hash => "ahash", :date => "2012-08-15", "command1" => 1, "command2" => 2}]
		writer.head(data).should eq('"hash","date","command1","command2"')
	end

	it "should be able to generate csv output" do
		writer = CSVWriter.new()
		data = [{:hash => "ahash", :date => "2012-08-15", "command1" => 1, "command2" => 2},{:hash => "bhash", :date => "2012-08-16", "command1" => 3, "command2" => 4}]
		writer.output(data).should eq("\"hash\",\"date\",\"command1\",\"command2\"\n\"ahash\",\"2012-08-15\",\"1\",\"2\"\n\"bhash\",\"2012-08-16\",\"3\",\"4\"")
	end
end