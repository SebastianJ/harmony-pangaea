module Harmony
  module Pangaea
    module Network
      class Balances
        class << self
          
          def balances(configuration: ::Harmony::Pangaea.configuration)
            data                  =   nil
            response              =   ::Harmony::Pangaea::Client.new(configuration: configuration).get("/pga/balances.json")
            
            if response&.success?
              data                =   {}
              nodes               =   response.body["onlineNodes"]
              
              nodes.each do |node|
                node              =   node.symbolize_keys
                
                if !node[:address].to_s.empty? && !node[:shard].to_s.empty? && !node[:totalBalance].to_s.empty?
                  address           =   node[:address]
                  shard             =   node[:shard]&.to_i
                  balance           =   node[:totalBalance]&.to_f
                  
                  data[shard]     ||=   []
                  data[shard]      <<   {address: address, balance: balance}
                end
              end
            end
            
            return data
          end
          
        end
      end
    end
  end
end
