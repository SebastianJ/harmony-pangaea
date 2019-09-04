module Harmony
  module Pangaea
    class Wallet
      
      class << self
        
        def send(from_address:, from_shard:, to_address:, to_shard:, amount: nil, daemonize: false)
          raise ArgumentError, "You need to specify the from address" if from_address.to_s.empty?
          raise ArgumentError, "You need to specify the from shard"   if from_shard.to_s.empty?
          raise ArgumentError, "You need to specify the to address"   if to_address.to_s.empty?
          raise ArgumentError, "You need to specify the to shard"     if to_shard.to_s.empty?
          raise ArgumentError, "You need to specify the amount"       if amount.to_s.empty?
        
          transaction_id  =   nil
          command         =   "#{::Harmony::Pangaea.configuration.wallet_script} transfer --from #{from_address} --to #{to_address} --amount #{amount} --shardID #{from_shard} --pass pass:"
          command         =   daemonize ? "#{command} > /dev/null 2>&1 &" : command
          output          =   nil
        
          puts "[Harmony::Pangaea::Wallet] - #{Time.now}: Running wallet command:\n#{command}" if ::Harmony::Pangaea.configuration.verbose
        
          if daemonize
            pid           =   Process.spawn(command)
          else
            output        =   `#{command}`
          end
        
          if !output.to_s.empty?
            puts "[Harmony::Pangaea::Wallet] - #{Time.now}: Output from wallet command:\n#{output}" if ::Harmony::Pangaea.configuration.verbose
            transaction_id        =   parse_transaction_id(output)
            puts "[Harmony::Pangaea::Wallet] - #{Time.now}: Successfully created transaction #{transaction_id}" if ::Harmony::Pangaea.configuration.verbose
          end
        
          return transaction_id
        end
      
        def parse_transaction_id(output, regex: /Transaction Id for shard \d+: /i)
          transaction_id          =   nil
        
          if !output.to_s.empty?
            rows                  =   output.split("\n").collect(&:strip)
          
            rows.each do |row|
              if row =~ regex
                transaction_id    =   row.gsub(regex, "")
                break
              end
            end
          end
        
          return transaction_id
        end
        
      end
         
    end
  end
end
