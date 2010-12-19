# -*- mode: ruby -*-

require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new(:specs) do |t|
  # t.rspec_opts = "--color --format documentation"
  t.rspec_opts = "--color"
end

task :default => :specs
