require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:spec) do |t|
  t.libs    = %w(lib spec)
  t.pattern = 'spec/**/*_spec.rb'
end

task :default => :spec

