# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.plugin :seattlerb

Hoe.spec 'seattlerb_dashboard' do
  developer('Ryan Davis', 'ryand-ruby@zenspider.com')

  self.rubyforge_name = 'seattlerb'
end

desc "Run tests quickly"
task :run do
  ruby "-Ilib bin/seattlerb_dashboard -f"
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
  sh "open http://www.zenspider.com/~ryand/dashboard/"
end

desc "Clean up dashboard and start over"
task :purge do
  Dir.chdir File.expand_path("~/Sites/dashboard") do
    rm Dir["*.{txt,yaml}"]
  end
end

# vim: syntax=ruby
