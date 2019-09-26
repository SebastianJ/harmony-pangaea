module Harmony
  module Pangaea
    class Configuration
      attr_accessor :address, :paths, :scripts, :hosts, :verbose, :faraday
    
      def initialize
        # Make sure to configure your address so the app knows who you are
        self.address      =   nil
        
        self.paths        =   {
          node:   "/root",
          wallet: "/root",
        }
        
        self.scripts      =   {
          node:   "#{self.node_path}/node.sh -t",
          wallet: "#{self.wallet_path}/wallet.sh -t",
          tx_sender: File.expand_path(File.join(File.dirname(__FILE__), '../../scripts/tx_sender.sh'))
        }
        
        self.hosts        =   {
          default: "https://harmony.one",
          explorer: "https://explorer.pangaea.harmony.one:8888"
        }
        
        self.verbose      =   false
        self.faraday      =   {adapter: :net_http}
      end
      
      def node_path
        self.paths[:node]
      end
      
      def wallet_path
        self.paths[:wallet]
      end
      
      def node_script
        self.scripts[:node]
      end
      
      def wallet_script
        self.scripts[:wallet]
      end
      
      def tx_sender_script
        self.scripts[:tx_sender]
      end
    
    end
  end
end
