module Harmony
  module Pangaea
    module Network
      class CsvParser
        attr_accessor :data
        
        def initialize
          self.data             =   {shards: {}, nodes: {online: 0, offline: 0}}
        end
        
        def parse(response)
          data                  =   ::CSV.new(response.body, headers: true, header_converters: :symbol, converters: nil).to_a.map { |row| row.to_hash }
          
          data.each do |item|
            address             =   item[:address]
            shard               =   item[:shard].to_i
            online              =   item[:online].to_s.downcase.eql?("true")
            status              =   online ? :online : :offline
            
            self.data[:nodes][status] += 1
            
            self.data[:shards][shard]         ||=   {}
            self.data[:shards][shard][:nodes] ||=   {online: [], offline: []}
            self.data[:shards][shard][:nodes][status] << address
          end
          
          return self.data
        end
        
      end
    end
  end
end
