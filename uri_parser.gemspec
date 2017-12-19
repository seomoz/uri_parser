# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "uri_parser/version"

Gem::Specification.new do |s|
  s.name        = "uri_parser"
  s.version     = URIParser::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = %w[Myron Marston]
  s.email       = %w[myron.marston@gmail.com]
  s.homepage    = "https://github.com/seomoz/uri_parser"
  s.summary     = "A fast URI parser and normalizer"
  s.description = "Parses and normalizes URIs very quickly, using Google's URI canonicalization library"

  s.rubyforge_project = "uri_parser"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extensions    = ["ext/uri_parser/extconf.rb"]
  s.require_paths = %w[ lib ext ]
  s.required_ruby_version = '>= 1.8.7'

  s.add_development_dependency 'rspec', '~> 3.7.0'
  s.add_development_dependency 'rspec-its', '~> 1.2.0'
  s.add_development_dependency 'rake-compiler', '~> 1.0.4'
end
