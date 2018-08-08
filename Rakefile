require "bundler/gem_tasks"
require "rake/testtask"
require 'rake/clean'
require 'coveralls/rake/task'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.options = '-p'
end
Coveralls::RakeTask.new
CLOBBER.include('coverage')

task :test_with_coveralls => [:test, 'coveralls:push']
task :default => :test
