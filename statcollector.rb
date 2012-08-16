require 'tmpdir'
require 'date'

class StatCollector
	attr_accessor :repo, :configuration
	def initialize(configuration, repo = GitRunner.new())
		@configuration = configuration
		@repo = repo
		@repo.setupRepo(@configuration)
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


		def setupRepo(conf)
			`cd #{conf.tmp_root} && git clone #{conf.location}`
		end

		def listCommits(conf)
			runCmd(conf,"git checkout master")
			return runCmd(conf,"git log --date=short --pretty='%H|%ad|'")
		end

		private

		def runCmd(conf,cmd)
		`cd #{conf.tmp_repo} && #{cmd}`
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

