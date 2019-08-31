module Harmony
  module Pangaea
    class Network
      attr_accessor :configuration, :client, :data, :regexes
      
      def initialize(configuration: ::Harmony::Pangaea.configuration)
        self.configuration    =   configuration
        
        self.data             =   {shards: {}, nodes: {}}
        
        self.regexes          =   {
          shard_status:      /Shard (?<shard_number>\d+) is on Block (?<block_number>\d+)\. Status is: (?<status>Online|Offline)\!\s*\(Last updated: (?<last_updated>[^\)]*)\)/i,
          nodes:             /(?<status>Online|Offline): (?<count>\d+) total/i,
          shard_node_status: /Shard (?<shard_number>\d+): (?<count>\d+) node(s)?/i,
          address:           /^one[a-z0-9]+$/
        }
        
        self.client           =   ::Harmony::Pangaea::Client.new(configuration: self.configuration)
      end
      
      def status
        response              =   self.client.get("/pga/network")
        
        if response && response.success?
          rows                =   response.body.split("\n").collect(&:strip)
          parse_shard_status(rows)
          parse_nodes(rows, status: :online)
          parse_nodes(rows, status: :offline)
        end
        
        return self.data
      end
      
      def parse_shard_status(rows)
        rows.each do |row|
          matches             =   row.match(self.regexes[:shard_status])
          
          if matches && matches.captures.any?
            shard_number      =   matches&.[](:shard_number)&.to_i
            block_number      =   matches&.[](:block_number)&.to_i
            status            =   matches&.[](:status)&.to_s&.downcase&.to_sym
            last_updated      =   matches&.[](:last_updated)
            last_updated      =   !last_updated.to_s.empty? ? DateTime.parse(last_updated) : nil
            
            puts "Shard #{shard_number} is #{status} and currently on block number #{block_number}. Last updated at #{last_updated}"
            
            self.data[:shards][shard_number]    =   {shard_number: shard_number, block_number: block_number, status: status, last_updated: last_updated}
          end
        end
      end
      
      def parse_nodes(rows, status: :online)
        found_status          =   nil
        current_shard         =   nil
        
        rows.each do |row|
          matches             =   row.match(self.regexes[:nodes])
          
          if matches && matches.captures.any?
            found_status      =   matches&.[](:status)&.to_s&.downcase&.to_sym
            
            if found_status.eql?(status)
              node_count      =   matches&.[](:count)&.to_i
              self.data[:nodes][status]    =   node_count
            end
          end
          
          if found_status.eql?(status)
            matches           =   row.match(self.regexes[:shard_node_status])
          
            if matches && matches.captures.any?
              current_shard   =   matches&.[](:shard_number)&.to_i
              node_count      =   matches&.[](:count)&.to_i
              
              self.data[:shards][current_shard]                       ||=   {}
              self.data[:shards][current_shard][:node_count]          ||=   {}
              self.data[:shards][current_shard][:node_count][status]    =   node_count
            end
          
            if row =~ self.regexes[:address]
              self.data[:shards][current_shard]                       ||=   {}
              self.data[:shards][current_shard][:nodes] ||= {online: [], offline: []}
              self.data[:shards][current_shard][:nodes][status] << row
            end
          end
          
        end
      end
      
    end
  end
end
