# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.spec 'seattlerb_dashboard' do
  developer('Ryan Davis', 'ryand-ruby@zenspider.com')

  self.rubyforge_name = 'seattlerb'
end

task :run do
  ruby "-Ilib bin/seattlerb_dashboard"
end

task :sync do
  Dir.chdir File.expand_path("~/Sites") do
    sh "./sync.sh"
  end
  sh "open http://www.zenspider.com/~ryand/dashboard/"
end

# vim: syntax=ruby
