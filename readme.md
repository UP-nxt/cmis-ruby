# CMIS ruby

[![Gem Version](https://img.shields.io/gem/v/cmis-ruby.svg)](https://rubygems.org/gems/cmis-ruby)
[![Dependency Status](http://img.shields.io/gemnasium/UP-nxt/cmis-ruby.svg)](https://gemnasium.com/UP-nxt/cmis-ruby)
[![Code Climate](http://img.shields.io/codeclimate/github/UP-nxt/cmis-ruby.svg)](https://codeclimate.com/github/UP-nxt/cmis-ruby)
[![Coverage Status](https://img.shields.io/coveralls/UP-nxt/cmis-ruby.svg)](https://coveralls.io/r/UP-nxt/cmis-ruby)

**CMIS ruby** is a [CMIS](http://chemistry.apache.org/project/cmis.html) client library, using the the _CMIS Browser Binding_ ([CMIS 1.1](http://docs.oasis-open.org/cmis/CMIS/v1.1/CMIS-v1.1.html)).

## Example usage

```ruby
require 'cmis'

# get the repository object
server = CMIS::Server.new(service_url: 'http://33.33.33.100:8080/browser',
                          username: 'foo', password: 'bar')
repository = server.repository('my_repository')

# get object by object id
document = repository.object('f3y5wbb6slhkeq3ciu3uazbpxeu')

# or by unique property
document = repository.find_object('cmis:document',
                                  'cmis:name' => 'some_unique_name')

# set document content
document.content = { stream: 'Apple is a fruit',
                     mime_type: 'text/plain',
                     filename: 'apple.txt' }

# create a new document
document = repository.new_document
document.name = 'new_document'
document.object_type_id = 'cmis:document'
document = document.create_in_folder(repository.root)

# query for first 50 documents where the property 'cmis:name' is 'bar'
query = repository.query("select * from cmis:document where cmis:name='bar'")
query.each_result(limit: 50) { |document| puts document.cmis_object_id }
```

## Running specs

The default rake task runs the specs. This requires a separate CMIS server. The environment variable `TEST_ENV` selects the test environment from `spec/config.yml`.

## Contributing

Write some code. Run the specs. Open a pull request.
