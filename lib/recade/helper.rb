require 'reversible_cryptography'

module Recade
  # interface with DB server
  module Helper
    class << self
      def secret
        secret_file = ENV['RECADE_SECRET_FILE']
        if @secret.nil?
          password = ENV['RECADE_SECRET_PASSWORD']
          encrypt_data = File.read(secret_file).strip
          decrypt_data = ReversibleCryptography::Message.decrypt(encrypt_data, password)
          @secret = YAML.load(decrypt_data)
        end
        @secret
      end
    end
  end
end
