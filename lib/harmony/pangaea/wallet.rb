module Harmony
  module Pangaea
    class Wallet
      
      def self.send(from_address:, from_shard:, to_address:, to_shard:, amount: nil)
        amount      ||=   0.00000001
        command       =   "#{::Harmony::Pangaea.configuration.wallet_script} transfer --from #{from_address} --shardID #{from_shard} --to #{to_address} --shardID #{to_shard} --amount #{amount} --pass pass:"
        output        =   nil
        
        puts "[Harmony::Pangaea::Wallet] - #{Time.now}: Running wallet command:\n#{command}" if ::Harmony::Pangaea.configuration.verbose
        
        IO.popen(command) do |io|
          output      =   io.gets&.strip
        end
        
        puts "[Harmony::Pangaea::Wallet] - #{Time.now}: Wallet output:\n#{output}" if ::Harmony::Pangaea.configuration.verbose
      end
            
    end
  end
end
