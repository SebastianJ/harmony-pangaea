module Harmony
  module Pangaea
    class Configuration
      attr_accessor :address, :scripts, :hosts, :verbose, :faraday
    
      def initialize
        # Make sure to configure your address so the app knows who you are
        self.address      =   nil
        
        self.scripts      =   {
          node:   "/root/node.sh -t",
          wallet: "/root/wallet.sh -t"
        }
        
        self.hosts        =   {
          default: "https://harmony.one",
          explorer: "https://explorer.pangaea.harmony.one:8888"
        }
        
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
