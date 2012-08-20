require './csvwriter.rb'

describe "The CSVWriter class" do
	it "should be able to write a header row" do
		writer = CSVWriter.new()
		data = [{:hash => "ahash", :date => "2012-08-15", "command1" => 1, "command2" => 2}]
		writer.head(data).should eq('"hash","date","command1","command2"')
	end
end