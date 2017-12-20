require 'net/ssh'
require 'net/ssh/gateway'
require 'mysql2'
require 'recade/helper'

module Recade
  # interface with DB server
  module Connection
    extend Helper
    class << self
      def open(host)
        locals = %w(local docker)
        if locals.include?(host)
          mysql_port = host == 'docker' ? 3366 : 3306
          client = Mysql2::Client.new(
              host: '127.0.0.1',
              username: 'pdns',
              port: mysql_port,
              password: Helper.secret['mysql_pdns_password']
          )
          yield(client)
        else
          gateway = Net::SSH::Gateway.new(*configure_ssh(host))
          gateway.open('127.0.0.1', '3306') do |port|
            client = Mysql2::Client.new(
                host: '127.0.0.1',
                username: 'pdns',
                port: port,
                password: Helper.secret['mysql_pdns_password']
            )
            yield(client)
          end
        end
      end

      def configure_ssh(host)
        config = Net::SSH::Config.for(host, [ENV['RECADE_SSH_CONFIG']])
        host = config[:host_name]
        user = config[:user]
        config.delete(:host_name)
        config.delete(:user)
        [host, user, config]
      end
    end
  end
end
