require 'cmis-ruby'

module SpecHelpers

  def server
    @server ||= CMIS::Server.new(options['server'])
  end

  def repository
    @repository ||= server.repository(options['repository'])
  end

  def repository_id
    options['repository']
  end

  private

  def options
    file = File.join(File.dirname(File.expand_path(__FILE__)), 'config.yml')
    config = YAML::load_file(file)
    test_env = ENV['TEST_ENV'] || 'local'

    if config.key?(test_env)
      config[test_env]
    else
      raise "No configuration found for #{test_env}"
    end
  end

end

RSpec.configure do |c|
  c.include SpecHelpers
end
