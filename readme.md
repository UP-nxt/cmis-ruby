# CMIS ruby

[![Gem Version](https://badge.fury.io/rb/cmis-ruby.png)](http://badge.fury.io/rb/cmis-ruby)
[![Code Climate](https://codeclimate.com/github/UP-nxt/cmis-ruby.png)](https://codeclimate.com/github/UP-nxt/cmis-ruby)
[![Build Status](https://travis-ci.org/UP-nxt/cmis-ruby.png?branch=master)](https://travis-ci.org/UP-nxt/cmis-ruby)
[![Dependency Status](https://gemnasium.com/UP-nxt/cmis-ruby.png)](https://gemnasium.com/UP-nxt/cmis-ruby)

**CMIS ruby** is a [CMIS](http://chemistry.apache.org/project/cmis.html) client library, using the the _CMIS Browser Binding_ ([CMIS 1.1](http://docs.oasis-open.org/cmis/CMIS/v1.1/CMIS-v1.1.html)).

## Example usage

#### `CMIS::Server` and `CMIS::Repository`

```ruby
server = CMIS::Server.new(service_url: 'http://33.33.33.100:8080/browser',
                          username: 'foo', password: 'bar')
repository = server.repository('my_repository')
```

#### `CMIS::document`

```ruby
# get by object id
document = repository.object('f3y5wbb6slhkeq3ciu3uazbpxeu')

# find by unique property
document = repository.find_object('cmis:document', 
                                  'cmis:name' => 'some_unique_name')

# set content
document.content = { stream: StringIO.new('Apple is a fruit'),
                     mime_type: 'text/plain',
                     filename: 'apple.txt' }

# create a new document
document = repository.new_document
document.name = 'new_document'
document.object_type_id = 'cmis:document'
document = document.create_in_folder(repository.root)
```

## Running specs

The default rake task runs the specs. This requires a separate CMIS server. The environment variable `TEST_ENV` selects the test environment from `spec/config.yml`. The Travis build uses the private `ci` environment.

## Contributing

Write some code. Run the specs. Open a pull request.
