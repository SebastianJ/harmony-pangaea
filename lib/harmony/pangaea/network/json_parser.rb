module Harmony
  module Pangaea
    module Network
      class JsonParser
        attr_accessor :data
        
        def initialize
          self.data             =   {shards: {}, nodes: {}}
        end
        
        def parse(response)
          self.data[:nodes]     =   response.body["node_count"].symbolize_keys
          
          response.body["shards"].each do |shard_number, data|
            parse_shard_status(data)
          end
          
          return self.data
        end
        
        def parse_shard_status(data)
          shard_number          =   data["shard_number"]
          block_number          =   data["block_number"]
          status                =   data["status"]&.to_s&.downcase&.to_sym
          last_updated          =   data["last_updated"]
          last_updated          =   !last_updated.to_s.empty? ? DateTime.parse(last_updated) : nil
          node_count            =   data["node_count"].symbolize_keys
          
          puts "Shard #{shard_number} is #{status} and currently on block number #{block_number}. Last updated at #{last_updated}"
          
          self.data[:shards][shard_number]    =   {shard_number: shard_number, block_number: block_number, status: status, last_updated: last_updated, node_count: node_count}
          
          parse_nodes(shard_number, data["nodes"])
        end
        
        def parse_nodes(shard, data)
          data.each do |status, nodes|
            self.data[:shards][shard]         ||=   {}
            self.data[:shards][shard][:nodes] ||=   {online: [], offline: []}
            
            nodes.each do |node|
              self.data[:shards][shard][:nodes][status.to_sym] << node
            end
          end
        end
        
      end
    end
  end
end
