# optics-agent-ruby
Apollo Optics agent for GraphQL Monitoring in Ruby.

[![Gem Version](https://badge.fury.io/rb/optics-agent.svg)](https://badge.fury.io/rb/optics-agent) [![Build Status](https://travis-ci.org/apollostack/optics-agent-ruby.svg?branch=master)](https://travis-ci.org/apollostack/optics-agent-ruby)


## Installing

Add

```ruby
gem 'optics-agent'
```

To your `Gemfile`

### API key

You'll need to run your app with the `OPTICS_API_KEY` environment variable set (or set via [`agent.configure`](#configuration)) to the API key of your Apollo Optics endpoint; you can get an API key by setting up a endpoint at https://optics.apollodata.com.

## Rails Setup

Create an agent in `config/initializers/optics_agent.rb`, and register the rack middleware:
```ruby
optics_agent = OpticsAgent::Agent.new
optics_agent.configure do
  schema YourSchema
  # See other configuration options below
end
Rails.application.config.middleware.use optics_agent.rack_middleware
```

Register Apollo Optics agent from your on the GraphQL context within your `graphql` action as below:
```ruby
def create
  query_string = params[:query]
  query_variables = ensure_hash(params[:variables])

  result = YourSchema.execute(
    query_string,
    variables: query_variables,
    context: {
      # This is the key line: we take the optics_agent passed in from the
      # Rack environment and pass it as context
      optics_agent: request.env[:optics_agent]
    }
  )

  render json: result
end
```

You can check out the GitHunt Rails API server example here: https://github.com/apollostack/githunt-api-rails

## General Setup

You must:

1. Create an agent with `OpticsAgent::Agent.new`
2. Register your schema with the `agent.configure` block
3. Attach the `agent.rack_middleware` to your Rack router
4. Ensure you pass the `optics_agent` context from the rack environment to your schema execution.

### Non-HTTP queries

If you aren't actually servicing a HTTP/Rack request in executing the query, simply pass:

```ruby
  context: { optics_agent: :no_rack }
```

This will mean the query is instrumented without HTTP timings or client versions.

### Skipping queries

If you want to skip a particular query, pass:

```ruby
  context: { optics_agent: :skip }
```

### Configuration

After creating an agent, you can configure it with (the values listed are the defaults):

```rb
# defaults are show below
agent.configure do
  # The schema you wish to instrument
  schema YourSchema

  # Your API key for the Optics service. This defaults to the OPTICS_API_KEY
  # environment variable, but can be overridden here.
  api_key ENV['OPTICS_API_KEY']

  # Log detailed debugging messages
  debug false

  # Don't report anything to Optics (useful for testing)
  disable_reporting false

  # Print JSON versions of the data sent to Optics to the log
  print_reports false

  # Send detailed traces along with usage reports
  report_traces true

  # How long to wait before sending a schema report after startup, in
  # milliseconds
  schema_report_delay_ms 10 * 1000

  # How often to send reports in milliseconds. Defaults to 1 minute.
  # You shouldn't need to set this unless you are debugging.
  report_interval_ms 60 * 1000

  # Where to send the reports. Defaults to the production Optics endpoint,
  # or the `OPTICS_ENDPOINT_URL` environment variable if it is set.
  # You shouldn't need to set this unless you are debugging
  endpoint_url 'https://optics-report.apollodata.com'
end
```

## Troubleshooting

The Apollo Optics agent is designed to allow your application to continue working, even if the agent is not configured properly.

### No data in Optics

If there is no data being sent to Optics, ensure you've followed the steps above, then check your application logs to look for the following messages:

### Message: No api_key set.

Solution: Get a valid API key from Optics and use the `OPTICS_API_KEY` environment variable, or [configuration](#configuration) to pass it to the agent.

### Message: No schema instrumented

Solution: Ensure you are passing your schema to the agent [configuration](#configuration).

### Message: No agent passed in graphql context

Solution: Ensure you are passing `context: { optics_agent: request.env[:optics_agent].with_document(query_string) }` where `request.env` is the Rack request environment, and `query_string` is the string representing your query. See the [setup instructions](#rails-setup) for more details.

### Debugging

You can also use the `debug` [configuration](#configuration) setting to get more detailed debugging information, which may give hints as to what the issue is.

## Development

### Running tests

```
bundle install
bundle exec rspec
```

### Building protobuf definitions

Ensure you've installed `protobuf` and development dependencies.

```bash
# this works on OSX
brew install protobuf

# ensure it's version 3
protoc --version

bundle install
````

Compile the `.proto` definitions with

```bash
bundle exec rake protobuf:compile
```
