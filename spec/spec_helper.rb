require 'coveralls'
Coveralls.wear!

require 'cmis'
require 'erb'
require 'yaml'

module SpecHelpers
  def server
    @@server ||= CMIS::Server.new(options['server'])
  end

  def repository_id
    @@repository_id ||= options['repository']
  end

  def repository
    @@repository ||= server.repository(repository_id)
  end

  private

  def options
    @@options ||= begin
      path = File.join(File.dirname(File.expand_path(__FILE__)), 'config.yml')
      config = YAML.load(ERB.new(File.read(path)).result)
      config[ENV.fetch('TEST_ENV', 'local')]
    end
  end
end

RSpec.configure do |c|
  c.include SpecHelpers
end
