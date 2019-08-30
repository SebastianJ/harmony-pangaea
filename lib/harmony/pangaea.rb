require "faraday"
require "logger"
require "date"

require "harmony/pangaea/version"

require "harmony/pangaea/configuration"

require "harmony/pangaea/client"
require "harmony/pangaea/network"
require "harmony/pangaea/wallet"

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
