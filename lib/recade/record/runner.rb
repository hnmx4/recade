require 'mysql2'
require 'recade/connection'
require 'recade/record/formatter'

module Recade
  module Record
    # generate query and run
    module Runner
      extend Connection

      class << self
        def dump(host)
          [].tap do |res|
            Connection.open(host) do |client|
              client.query('select * from pdns.records').each do |row|
                res.push(row)
              end
            end
          end
        end

        def sync(host, new_records)
          existing_records = dump(host)
          delete(host, existing_records, new_records)
          insert(host, existing_records, new_records)
          update(host, existing_records, new_records)
        end

        def delete(host, existing_records, new_records)
          ids = Formatter.extract_delete_ids(existing_records, new_records)
          Connection.open(host) do |client|
            ids.each do |id|
              client.query("DELETE FROM pdns.records WHERE id=#{id}")
            end
          end
        end

        def insert(host, existing_records, new_records)
          records = Formatter.extract_insert_records(existing_records, new_records)
          Connection.open(host) do |client|
            records.each do |record|
              cols = record.keys.join(',')
              vals = record.values.map { |val| process_for_query(val) }.join(',')
              client.query("INSERT INTO pdns.records (#{cols}) VALUES (#{vals})")
            end
          end
        end

        def update(host, existing_records, new_records)
          records = Formatter.extract_update_records(existing_records, new_records)
          Connection.open(host) do |client|
            records.each do |record|
              doubles = format_doubles(record)
              client.query(
                "UPDATE pdns.records SET #{doubles} WHERE id=#{record['id']}"
              )
            end
          end
        end

        def truncate(host)
          Connection.open(host) do |client|
            client.query('TRUNCATE pdns.records')
          end
        end

        def process_for_query(val)
          case val
          when Numeric then val
          when NilClass then 'NULL'
          else '\'' + val.to_s + '\''
          end
        end

        def format_doubles(record)
          enclose = ->(val) { process_for_query(val) }
          doubles = []
          record.each do |col, val|
            next if col == 'id'
            doubles.push("#{col}=#{enclose[val]}")
          end
          doubles.join(',')
        end
      end
    end
  end
end
