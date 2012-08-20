GitStats
========
GitStats helps you find out how a git repository has changed over time by allowing you to run a number of commands on every commit, collecting the results into a CSV file so you can analyse how your code has changed over time.

Usage
-----
To use GitStats you need to create a configuration file that defines the repo and the commands that should be run on it.

Example:

	name: project-euler-scala
	location: git://github.com/mikeyhu/project-euler-scala.git
	max: 0
	one_per_day:false

	collect:
 		#count all tests in .scala files
 		scala-tests: 'find src -iname *.scala | xargs -I{} grep "test(" {} | wc -l'



Options in the config file:

* name 			- name of the repo.
* location 		- location of the repo, this can either be a local directory or a remote repository
* max			- (numeric) Maximum number of commits to retrieve. Leave blank or set to 0 to analyse all commits
* one_per_day	- (true or false) Only analyse a maximum of 1 commit per day. This is useful for long running repositories
* collect 		- List of commands to run on each commit along with a name for each.

How it works
------------
GitStats will check out the chosen repository into a temporary location and will then checkout each commit backwards in turn. This means that choosing a max: number will get just the latest commits.

Commands
--------
GitStats will execute each command on each commit by `cd`ing to the temp checkout location and running each command in turn. What commands can be run is dependant on the OS of the computer. Currently the script only supports numeric data and therefore `wc -l` is normally useful to run at the end to count the number of results.

To run
------
Just use:

	./statrunner.rb yourYAMLfile

