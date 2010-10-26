require 'rake'
require 'spec/rake/spectask'

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/unit/*_spec.rb']
end

task :default => :spec
