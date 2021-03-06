# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.plugin :seattlerb

Hoe.spec 'seattlerb_dashboard' do
  developer('Ryan Davis', 'ryand-ruby@zenspider.com')

  license "MIT"

  dependency "flog", "> 0"
  dependency "flay", "> 0"
  dependency "tagz", "> 0"
end

ENV["MT_NO_ISOLATE"] = "1"
ENV["GEM_PATH"] = File.expand_path "tmp"
ENV["PATH"]     = File.expand_path("tmp/bin:") + ENV["PATH"]

desc "Run tests quickly"
task :run do
  ruby "-Ilib bin/seattlerb_dashboard -f"
end

task :triage do
  ruby "./shipit > TODO_releases.tmp"
  puts
  mv "TODO_releases.tmp", "TODO_releases.txt"
  puts File.read "TODO_releases.txt"
end

desc "Run tests quickly"
task :fast do
  ruby "-Ilib bin/seattlerb_dashboard -f -r"
end

desc "Run tests thoroughly"
task :full do
  ruby "-Ilib bin/seattlerb_dashboard"
end

desc "Sync the dashboard to the server"
task :sync do
  Dir.chdir File.expand_path("~/Sites") do
    sh "./sync.sh"
  end
  sh "open -g http://www.zenspider.com/~ryand/dashboard/"
end

desc "Clean up dashboard and start over"
task :purge do
  Dir.chdir File.expand_path("~/Sites/dashboard") do
    rm Dir["*.{txt,yaml}"]
  end
end

desc "Clean up dashboard and start over"
task :force do
  Dir.chdir File.expand_path("~/Sites/dashboard") do
    rm `egrep -l 'Failure|Error' *.yaml`.lines.map(&:chomp)
  end
end

task :gems do
  sh "gem i -i tmp tagz flog flay -N"
end

task :projects do
  $: << "lib"
  require "seattlerb_projects"

  all  = SeattlerbProjects.new.projects
  all.pop unless ENV["ALL"] # remove toys

  all = all.flatten.map(&:downcase)
  have = Dir.chdir File.expand_path "~/Work/p4/zss/www/zenspider.com/" do
    Dir["projects/*.md.erb"].map { |s| File.basename s, ".html.md.erb" }
  end

  # have = `of projects`.scan(/: ([\w ]+?) \(/).flatten.uniq.sort_by(&:downcase)

  unless (all - have).empty? then
    warn "Needs projects file on website"

    (all - have).sort_by(&:downcase).each do |proj|
      warn proj
    end
  end
end

# vim: syntax=ruby
