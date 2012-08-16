require 'tmpdir'
require 'date'

class StatCollector
	attr_accessor :repo, :configuration
	def initialize(configuration, repo = GitRunner.new(configuration))
		@configuration = configuration
		@repo = repo
		repo.setupRepo
	end

	def commits()
		commits = []
		@repo.listCommits(@configuration).each_line do |line|
	    	parts = line.split('|')
	    	commits << {:hash=>parts[0], :date=>parts[1]}
	    end
	    commits
	end

	class GitRunner

		def initialize()
		end

		def setupRepo()
			`cd #{tmp_root} && git clone #{@conf["location"]}`
		end

		def listCommits()
			
		end
	end

end

class StatConfiguration
	attr_accessor :max, :name, :location, :collect, :tmp_repo, :tmp_root

	def initialize(yaml)
		raise "Configuration must include a location" if yaml["location"].nil?
		@location = yaml["location"]
		@max = yaml["max"]||=0
		@name = yaml["name"]
		@collect = yaml["collect"]
		@tmp_root = Dir.mktmpdir
		@tmp_repo = @tmp_root + "/" + @name

	end
end

