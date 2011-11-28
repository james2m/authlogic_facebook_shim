#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

desc 'Generate documentation for the authlogic_facebook_shim gem.'
RDoc::Task.new(:rdoc) do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'authlogic_facebook_shim #{version}'
  rdoc.main     = 'README.rdoc'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc', 'lib/**/*.rb')
end

Bundler::GemHelper.install_tasks

require 'rake/testtask'

desc 'Test the authlogic_facebook_shim gem.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

namespace :rcov do

  desc "Generate a coverage report in coverage/"
  task :gen do
    sh "rcov --output coverage test/*_test.rb --exclude 'gems/*'"
  end

  desc "Remove generated coverage files."
  task :clobber do
    sh "rm -rdf coverage"
  end

end

desc 'Default: run unit tests.'
task :default => :test
