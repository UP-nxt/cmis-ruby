require 'cmis-ruby'
require 'coveralls'
require 'erb'
require 'yaml'

Coveralls.wear!

module SpecHelpers
  def server
    @@server ||= CMIS::Server.new(options['server'])
  end

  def repository
    @@repository ||= server.repository(repository_id)
  end

  def repository_id
    @@repository_id ||= options['repository']
  end

  private

  def options
    path = File.join(File.dirname(File.expand_path(__FILE__)), 'config.yml')
    config = YAML.load ERB.new(File.read(path)).result

    test_env = ENV['TEST_ENV'] || 'local'
    if config.key?(test_env)
      config[test_env]
    else
      raise "No configuration found for environment `#{test_env}`"
    end
  end
end

RSpec.configure do |c|
  c.include SpecHelpers
end
