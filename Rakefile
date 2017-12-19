require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/extensiontask'
Rake::ExtensionTask.new('uri_parser') do |ext|
  ext.lib_dir = File.join('lib', 'uri_parser')
  ext.source_pattern = "*.{c,cpp,cc,h}"
end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(spec: :compile)
task default: :spec
