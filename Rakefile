require 'bundler'
Bundler::GemHelper.install_tasks

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

require 'rake/extensiontask'
Rake::ExtensionTask.new('uri_parser')

