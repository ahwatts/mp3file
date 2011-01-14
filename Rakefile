# -*- mode: ruby -*-

# Monkey-patch to fix the interaction of Rake and Bundler on Windows.
if Rake.application.rakefile_location =~ /:in `rakefile_location/
  class Rake::Application
    def rakefile_location
      File.expand_path(File.basename(__FILE__))
    end
  end
end

require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new(:specs) do |t|
  # Don't do color on Windows.
  arch, platform = RUBY_PLATFORM.split('-')
  if platform !~ /^mswin/ && platform !~ /^mingw/
    t.rspec_opts = "--color"
  end
end

task :default => :specs
