require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
#require 'puppet-lint'

require 'rake'
require 'rspec/core/rake_task'
require 'puppet-lint/tasks/puppet-lint'

desc "Run the tests"
RSpec::Core::RakeTask.new(:do_test) do |t|
  t.rspec_opts = ['--color', '-f d']
  t.pattern = 'spec/*/*_spec.rb'
end

PuppetLint.configuration.ignore_paths = ["vendor/**/*.pp", "spec/**/*.pp"]
PuppetLint.configuration.send("disable_80chars")
PuppetLint.configuration.send("disable_class_inherits_from_params_class")
PuppetLint.configuration.send("disable_autoloader_layout")

task :default => [:spec_prep, :do_test, :lint]
task :clean   => [:spec_clean]
task :test    => [:default]
