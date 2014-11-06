# -*- mode: ruby; encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require "empythree/version"

Gem::Specification.new do |s|
  s.name        = "empythree"
  s.version     = Empythree::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andrew Watts"]
  s.email       = ["ahwatts@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/empythree"
  s.summary     = %q{Reads MP3 headers and returns their information.}
  s.description = %q{Reads MP3 headers and returns their information.}

  s.rubyforge_project = "empythree"

  s.add_development_dependency("rspec")
  s.add_development_dependency("rspec-its")
  s.add_development_dependency("rake")
  s.add_dependency('bindata', "~> 1.5.0")

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
