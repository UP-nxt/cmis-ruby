# cmis-ruby

**cmis-ruby** is a [CMIS](http://chemistry.apache.org/project/cmis.html) client library, using the the CMIS browser binding ([CMIS 1.1](http://docs.oasis-open.org/cmis/CMIS/v1.1/CMIS-v1.1.html)) for Ruby.

## Running Specs

Running the tests requires a separate CMIS server and two environment variables:

- `CMIS_BROWSER_URL` – The URL of the CMIS server's browser binding.
- `TEST_REPOSITORY_ID` – The ID of the configured repository that can be used for running the specs on that server.

The default rake task runs the specs.

## TODO

* facilitate copy between servers (make a flow)
* caching

## Contributing

Write some code. Run the specs. Open a pull request.
