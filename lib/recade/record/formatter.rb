# coding: utf-8
require 'pp'
require 'recade/record/validation'

module Recade
  module Record
    # format record from YAML and DB
    module Formatter
      extend Record::Validation

      class << self
        def extract_delete_ids(existing_records, new_records)
          existing_records.map do |ex_rec|
            ex_rec['id'] unless include_record?(ex_rec, new_records)
          end.compact
        end

        def extract_insert_records(existing_records, new_records)
          new_records.map do |new_rec|
            Validation.valid?(new_rec)
            fit_template(new_rec) unless include_record?(new_rec, existing_records)
          end.compact
        end

        def extract_update_records(existing_records, new_records)
          existing_records.map do |ex_rec|
            same_record = find_record(ex_rec, new_records)
            Validation.valid?(same_record) unless same_record.nil?
            fit_template(update_record_id(same_record, ex_rec)) unless same_record.nil?
          end.compact
        end

        def include_record?(record, record_list)
          !!find_record(record, record_list)
        end

        def find_record(record, record_list)
          record_list.find { |rec| eql_record?(record, rec) } unless record_list.empty?
        end

        def update_record_id(updated_record, source_record)
          updated_record['id'] = source_record['id']
          updated_record
        end

        def eql_record?(rec1, rec2)
          fe1 = extract_feature(rec1)
          fe2 = extract_feature(rec2)
          fe1.eql?(fe2)
        end

        def extract_feature(rec)
          [rec['name'], rec['type'], rec['content']]
        end

        def fit_template(rec)
          { 'domain_id'   => nil, 'name'     => nil,
            'type'        => nil, 'content'  => nil,
            'ttl'         => nil, 'prio'     => nil,
            'change_date' => nil, 'disabled' => 0,
            'ordername'   => nil, 'auth'     => 1 }.tap do |temp|
            rec.each { |k, v| temp[k] = v }
          end
        end
      end
    end
  end
end
