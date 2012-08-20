GitStats
========
GitStats helps you find out how a git repository has changed over time by allowing you to run a number of commands on every commit, collecting the results into a CSV file so you can analyse how your code has changed over time.

Usage
-----
To use GitStats you need to create a configuration file that defines the repo and the commands that should be run on it.

Example:

	name: aim
	location: ~/casper/aim
	max: 0

	collect:
		traits-main: 'find src/main -iname *.scala | xargs -t -I{} grep "trait" {} 2>&1 | grep -b1 -v "grep" | grep "grep" | sed "s/.*trait //g" | wc -l'
		traits-test: 'find src/test -iname *.scala | xargs -t -I{} grep "trait" {} 2>&1 | grep -b1 -v "grep" | grep "grep" | sed "s/.*trait //g" | wc -l'


Options in the config file:

name 		- name of the repo.
location 	- location of the repo, this can either be a local directory or a remote repository
max			- (numeric) Maximum number of commits to retrieve. Leave blank or set to 0 to analyse all commits
one_per_day	- (true or false) Only analyse a maximum of 1 commit per day. This is useful for long running repositories

collect 	- List of commands to run on each commit


To run
------
Just use:

	./statrunner.rb yourYAMLfile

