$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
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
    YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), 'config.yml'))
  end

end

RSpec.configure do |c|
  c.include SpecHelpers
end
