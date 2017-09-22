Install the Rubygem to your `Gemfile`:

```ruby
gem 'optics-agent'
```

And run

```bash
bundle install
```

Set the `OPTICS_API_KEY` environment variable to the API key shown above.

Create an agent in `config/initializers/optics_agent.rb`, and register the rack middleware:

```ruby
optics_agent = OpticsAgent::Agent.new
optics_agent.configure { schema YourSchema }
Rails.application.config.middleware.use \
  optics_agent.rack_middleware
```

Register Optics Agent on the GraphQL context within your `graphql` action as below:

```ruby
def create
  query_string = params[:query]
  query_variables = ensure_hash(params[:variables])

  result = YourSchema.execute(
    query_string,
    variables: query_variables,
    context: {
      optics_agent: request.env[:optics_agent].with_document(query_string)
    }
  )

  render json: result
end
```

For more details, see [the optics-agent-ruby README](https://github.com/apollostack/optics-agent-ruby/blob/master/README.md#rails-setup).
