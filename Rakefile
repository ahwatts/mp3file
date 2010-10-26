# -*- mode: ruby -*-

require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--color --format documentation"
end

task :default => :spec
