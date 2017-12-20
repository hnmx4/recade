require 'recade/record/formatter'
require 'recade/record/runner'

module Recade
  module Record
    # interface for user
    class Interface
      extend Record::Runner
      @host

      def initialize(host)
        @host = host
      end

      def dump
        Record::Runner.dump(@host)
      end

      def sync(filename)
        begin
          new_records = YAML.load_file(filename)
          Record::Runner.sync(@host, new_records)
        rescue Record::ValidationError => e
          p e
          exit
        end
      end
    end
  end
end
