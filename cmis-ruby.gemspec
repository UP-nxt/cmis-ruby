$LOAD_PATH.unshift 'lib'
require 'cmis/version'

Gem::Specification.new do |s|
  s.name                  = 'cmis-ruby'
  s.version               = CMIS::VERSION
  s.date                  = Time.now.strftime('%Y-%m-%d')
  s.authors               = ['Kenneth Geerts', 'Michael Brackx']
  s.email                 = ['kenneth@up-nxt.com']
  s.homepage              = 'https://github.com/UP-nxt'
  s.summary               = 'Ruby client for CMIS'
  s.license               = 'Apache-2.0'
  s.has_rdoc              = false

  s.files                 = `git ls-files`.split($/)
  s.executables           = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files            = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths         = %w( lib )

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency        'faraday', '~> 0.9'

  s.description = <<-DESCRIPTION
CMIS browser binding client library in ruby.
DESCRIPTION
end
