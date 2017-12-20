require 'yaml'
require 'thor'
require 'recade/record/interface'

module Recade
  # interface
  class CLI < Thor
    desc 'dump', 'dump records table'
    def dump(host)
      record = Record::Interface.new(host)
      print(record.dump.to_yaml)
    end

    desc 'sync host filename', 'sync records table'
    def sync(host, filename)
      record = Record::Interface.new(host)
      record.sync(filename)
    end
  end
end
