module Harmony
  module Pangaea
    class Configuration
      attr_accessor :address, :scripts, :host, :verbose, :faraday
    
      def initialize
        # Make sure to configure your address so the app knows who you are
        self.address      =   nil
        
        self.scripts      =   {
          node:   "/root/node.sh -t",
          wallet: "/root/wallet.sh -t"
        }
        
        self.host         =   "https://harmony.one"
        self.verbose      =   false
        self.faraday      =   {adapter: :net_http}
      end
      
      def node_script
        self.scripts[:node]
      end
      
      def wallet_script
        self.scripts[:wallet]
      end
    
    end
  end
end
