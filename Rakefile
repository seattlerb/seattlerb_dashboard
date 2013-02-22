# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.plugin :seattlerb

Hoe.spec 'seattlerb_dashboard' do
  developer('Ryan Davis', 'ryand-ruby@zenspider.com')

  dependency "erector", "~> 0.8.2"

  self.rubyforge_name = 'seattlerb'
end

ENV["GEM_PATH"] = File.expand_path "tmp"
ENV["PATH"]     = File.expand_path("tmp/bin:") + ENV["PATH"]

desc "Run tests quickly"
task :run do
  ruby "-Ilib bin/seattlerb_dashboard -f"
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
  sh "gem i -i tmp erector flog flay --no-ri --no-rdoc"
end

# vim: syntax=ruby
