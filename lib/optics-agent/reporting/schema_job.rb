require 'sucker_punch'
require 'optics-agent/reporting/schema'

module OpticsAgent::Reporting
  class SchemaJob
    include SuckerPunch::Job

    def perform(agent)
      puts 'performing schema job'
      schema = OpticsAgent::Reporting::Schema.new agent.schema
      schema.send
    end
  end
end
