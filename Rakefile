# -*- mode: ruby -*-

require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

task :default => [ 'spec:run' ]

namespace :spec do
  desc "Run all specs"
  RSpec::Core::RakeTask.new('run') do |t|
    t.pattern = 'spec/*.rb'
  end
end
