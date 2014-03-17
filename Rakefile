require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ['--options', 'spec/rspec.opts']
end

task default: [:spec]
