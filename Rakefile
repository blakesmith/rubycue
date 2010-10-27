require 'rake'
require 'spec/rake/spectask'

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/unit/*_spec.rb']
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
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

