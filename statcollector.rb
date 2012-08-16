require 'tmpdir'
require 'date'

class StatCollector
	attr_accessor :tmp_repo, :tmp_root, :repo
	def initialize(configuration, repo = GitRunner.new)
		@tmp_root = Dir.mktmpdir
		@tmp_repo = @tmp_root + "/" + configuration.name
		@repo = repo
	end

	def commits()
		commits = []
		@repo.listCommits.each_line do |line|
	    	parts = line.split('|')
	    	commits << {:hash=>parts[0], :date=>parts[1]}
	    end
	    commits
	end

	class GitRunner

		def initialize()
		end

		def listCommits()
		end
	end

end

class StatConfiguration
	attr_accessor :max, :name, :location, :collect

	def initialize(yaml)
		raise "Configuration must include a location" if yaml["location"].nil?
		@location = yaml["location"]
		@max = yaml["max"]||=0
		@name = yaml["name"]
		@collect = yaml["collect"]

	end
end

