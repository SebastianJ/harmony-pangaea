module Harmony
  module Pangaea
    class Wallet
      
      class << self
        
        def send(from_address:, from_shard:, to_address:, to_shard:, amount: nil, use_wrapper_script: true, binary: :cross_shard, input_data: nil, daemonize: false)
          raise ArgumentError, "You need to specify the from address" if from_address.to_s.empty?
          raise ArgumentError, "You need to specify the from shard"   if from_shard.to_s.empty?
          raise ArgumentError, "You need to specify the to address"   if to_address.to_s.empty?
          raise ArgumentError, "You need to specify the to shard"     if to_shard.to_s.empty?
          raise ArgumentError, "You need to specify the amount"       if amount.to_s.empty?
        
          transaction_id  =   nil
          command         =   nil
          output          =   nil
          
          if use_wrapper_script
            command       =   generate_wrapper_script_invocation(from_address: from_address, from_shard: from_shard, to_address: to_address, to_shard: to_shard, amount: amount, binary: binary, input_data: input_data, daemonize: daemonize)
          else
            command       =   generate_wallet_script_invocation(from_address: from_address, from_shard: from_shard, to_address: to_address, to_shard: to_shard, amount: amount, binary: binary, input_data: input_data, daemonize: daemonize)
          end

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
        
        def generate_wallet_script_invocation(from_address:, from_shard:, to_address:, to_shard:, amount: nil, binary: :cross_shard, input_data: nil, daemonize: false)
          wallet_script   =   ::Harmony::Pangaea.configuration.wallet_script
          command         =   "#{wallet_script} transfer --from #{from_address} --to #{to_address} --amount #{amount} --shardID #{from_shard}"
          command        +=   " --toShardID #{to_shard}" if binary.to_sym.eql?(:cross_shard)
          command        +=   " --pass pass:"
          command        +=   " --inputData #{input_data}" unless input_data.to_s.empty?
          command         =   daemonize ? "#{command} > /dev/null 2>&1 &" : command
          
          return command
        end
        
        def generate_wrapper_script_invocation(from_address:, from_shard:, to_address:, to_shard:, amount: nil, binary: :cross_shard, input_data: nil, daemonize: false)
          wallet_script   =   ::Harmony::Pangaea.configuration.tx_sender_script
          wallet_path     =   ::Harmony::Pangaea.configuration.wallet_path
          command         =   "#{wallet_script} -w #{wallet_path} -f #{from_address} -t #{to_address} -a #{amount} -x #{from_shard} -y #{to_shard}"
          command        +=   " -i #{input_data}" unless input_data.to_s.empty?
          command         =   daemonize ? "#{command} > /dev/null 2>&1 &" : command
          
          return command
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
