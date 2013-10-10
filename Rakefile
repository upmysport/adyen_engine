begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
require "rspec/core/rake_task"

begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

Dir['tasks/*.rake'].each { |file| load(file) }



RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = "./spec/**/*_spec.rb"
  task.rspec_opts = ['--color']
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Adyen'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'


Bundler::GemHelper.install_tasks

begin
  require 'rubygems'
  require 'yard'
  require File.expand_path('../yard_extensions', __FILE__)
  YARD::Rake::YardocTask.new do |y|
    y.options << '--no-private' << '--title' << "The 'Adyen payment service' library for Ruby"
  end
rescue LoadError
end

task :default => [:spec]
