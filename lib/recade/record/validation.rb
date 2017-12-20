# -*- coding: utf-8 -*-
require 'recade/record/error'

module Recade
  module Record
    # validate records
    module Validation
      class << self
        def validate_name
          symbol = /[\-]/
          jp = /(\p{Hiragana}|\p{Katakana}|[一-龠])/
          jp_symbol = /[・ヽヾゝゞ仝々〆〇ー]/
          ends = /(\w|#{jp}|#{jp_symbol})/
          middle = /(\w|#{symbol}|#{jp}|#{jp_symbol}){0,61}/
          domain = /(#{ends}#{middle}#{ends}\.)|(\*\.)/
          tld = /[a-z]{2,}|(コム)/
          /#{domain}*?#{tld}/
        end

        def validate_content(type)
          name = validate_name
          case type
            when 'A' then
              /^(\d{1,3}\.){3}\d{1,3}$/
            when 'SOA' then
              /^(\d{1,3}\.){4}\s#{name}\.\s\d+\s\d+\s\d+\s\d+\s\d+$/
            when 'TXT' then
              /^\".{1,255}\"(\s\".{1,255}\")*$/
            else
              /((\d{1,3}\.){3}\d{1,3})|#{name}/
          end
        end

        def valid?(record)
          {
              'name' => /^#{validate_name}$/,
              'type' => /^[A-Z]{1,255}$/,
              'content' => validate_content(record['type'])
          }.tap do |valid|
            valid.keys.each do |k|
              raise Record::ValidationError, "invalid value with #{k}: \"#{record[k]}\" in #{record}" unless record[k] =~ valid[k]
            end
          end
          true
        end
      end
    end
  end
end
