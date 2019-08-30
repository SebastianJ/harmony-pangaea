module Harmony
  module Pangaea
    class Wallet
      
      def self.send(from_address:, from_shard:, to_address:, to_shard:, amount: nil, daemonize: false)
        raise ArgumentError, "You need to specify the from address" if from_address.to_s.empty?
        raise ArgumentError, "You need to specify the from shard"   if from_shard.to_s.empty?
        raise ArgumentError, "You need to specify the to address"   if to_address.to_s.empty?
        raise ArgumentError, "You need to specify the to shard"     if to_shard.to_s.empty?
        raise ArgumentError, "You need to specify the amount"       if amount.to_s.empty?
        
        transaction_id  =   nil
        command         =   "#{::Harmony::Pangaea.configuration.wallet_script} transfer --from #{from_address} --shardID #{from_shard} --to #{to_address} --shardID #{to_shard} --amount #{amount} --pass pass:"
        command         =   daemonize ? "#{command} > /dev/null 2>&1 &" : command
        output          =   nil
        
        puts "[Harmony::Pangaea::Wallet] - #{Time.now}: Running wallet command:\n#{command}" if ::Harmony::Pangaea.configuration.verbose
        
        if daemonize
          pid           =   Process.spawn(command)
        else
          output        =   `#{command}`
        end
        
        puts "[Harmony::Pangaea::Wallet] - #{Time.now}: Output from wallet command:\n#{output}" if ::Harmony::Pangaea.configuration.verbose && !output.to_s.empty?
        
        return transaction_id
      end
            
    end
  end
end
