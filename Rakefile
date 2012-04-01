require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = './spec/unit/*_spec.rb'
end

task :default => :spec

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "rubycue"
    gemspec.summary = "Ruby cuesheet track parser"
    gemspec.description = "Basic ruby parser for song cuesheets"
    gemspec.email = "blakesmith0@gmail.com"
    gemspec.homepage = "http://github.com/blakesmith/rubycue"
    gemspec.authors = ["Blake Smith"]
    gemspec.executables = ["cuechapter"]
    gemspec.add_dependency 'builder', '>= 3.0.0'
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

