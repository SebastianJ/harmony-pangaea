require "faraday"
require "faraday_middleware"
require "csv"
require "logger"
require "date"

require "harmony/pangaea/version"

require "harmony/pangaea/configuration"

require "harmony/pangaea/client"
require "harmony/pangaea/network/text_parser"
require "harmony/pangaea/network/json_parser"
require "harmony/pangaea/network/csv_parser"
require "harmony/pangaea/network/status"
require "harmony/pangaea/network/balances"
require "harmony/pangaea/wallet"
require "harmony/pangaea/explorer"

if !Hash.instance_methods(false).include?(:symbolize_keys)
  require "harmony/pangaea/extensions/hash"
end

module Harmony
  module Pangaea
    
    class << self
      attr_writer :configuration
    
      def configuration
        @configuration ||= ::Harmony::Pangaea::Configuration.new
      end

      def reset
        @configuration = ::Harmony::Pangaea::Configuration.new
      end

      def configure
        yield(configuration)
      end
    end
    
    class Error < StandardError; end
    
  end
end
