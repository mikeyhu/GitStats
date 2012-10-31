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
		@repo.checkout(@configuration,commit[:hash])
		data = {
			:hash	=> commit[:hash],
			:date	=> commit[:date]
		}
		@configuration.collect.each {|name,command| data["#{name}"] = @repo.runCmd(@configuration,command).to_i }
		data
	end

	def get_statistics()
		current = 0
		date = Date.today.next_day.to_s
		commits()
			.keep_if{|commit|(@configuration.one_per_day==false || commit[:date] < date) && date = commit[:date]}
			.keep_if{|commit|@configuration.max==0 || @configuration.max >= (current += 1)}
			.map {|commit|checkout_and_collect(commit)}
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
	attr_accessor :max, :name, :location, :collect, :tmp_repo, :tmp_root, :one_per_day, :decending

	def initialize(yaml)
		raise "Configuration must include a location" if yaml["location"].nil?
		@location = yaml["location"]
		@max = yaml["max"]||=0
		@one_per_day = yaml["one_per_day"]||=false
		@name = yaml["name"]
		@collect = yaml["collect"]
		@decending = yaml["decending"]||=false
		@tmp_root = Dir.mktmpdir
		@tmp_repo = @tmp_root + "/" + @name

	end
end

