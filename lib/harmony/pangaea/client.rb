module Harmony
  module Pangaea
    class Client
      attr_accessor :configuration, :client
      
      def initialize(configuration: ::Harmony::Pangaea.configuration)
        self.configuration        =   configuration
        
        self.client               =   ::Faraday.new(self.configuration.host) do |builder|
          builder.response :logger, ::Logger.new(STDOUT), bodies: true if self.configuration.verbose
          builder.response :json, content_type: /\bjson$/
          builder.adapter self.configuration.faraday.fetch(:adapter, ::Faraday.default_adapter)
        end
      end
    
      def get(path, parameters: {}, headers: {}, options: {})
        request path, method: :get, parameters: parameters, headers: headers, options: options
      end
    
      def request(path, method: :get, parameters: {}, data: {}, headers: {}, options: {})        
        response                  =   case method
          when :get
            self.client.get do |request|
              request.url path unless path.to_s.empty?
              request.headers     =   self.client.headers.merge(headers)
              request.params      =   parameters if parameters && !parameters.empty?
            end
          when :head
            self.client.head do |request|
              request.url path unless path.to_s.empty?
              request.headers     =   self.client.headers.merge(headers)
              request.params      =   parameters if parameters && !parameters.empty?
            end
          when :post, :put, :patch, :delete
            self.client.send(method) do |request|
              request.url path unless path.to_s.empty?
              request.headers     =   self.client.headers.merge(headers)
              request.body        =   data if data && !data.empty?
              request.params      =   parameters if parameters && !parameters.empty?
            end
        end
      end
      
    end
  end
end
