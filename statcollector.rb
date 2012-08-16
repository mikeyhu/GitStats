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

	def checkout_and_collect(commit)
		data = {
			:hash	=> commit[:hash],
			:date	=> commit[:date]
		}
		@configuration.collect.each {|name,command| data["#{name}"] = @repo.runCmd(@configuration,command).to_i }
		data
	end

	class GitRunner


		def setupRepo(conf)
			`cd #{conf.tmp_root} && git clone #{conf.location}`
		end

		def listCommits(conf)
			runCmd(conf,"git checkout master")
			return runCmd(conf,"git log --date=short --pretty='%H|%ad|'")
		end

		def checkout(conf,hash)
			runCmd(conf,"git checkout #{hash}")
		end

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

