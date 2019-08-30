module Harmony
  module Pangaea
    class Configuration
      attr_accessor :host, :verbose, :faraday
    
      def initialize
        self.host         =   "https://harmony.one"
        self.verbose      =   false
        self.faraday      =   {adapter: :net_http}
      end
    
    end
  end
end
