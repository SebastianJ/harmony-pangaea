module Harmony
  module Pangaea
    class Explorer
      class << self
        
        def successful_transaction?(tx_id, configuration: ::Harmony::Pangaea.configuration)
          response    =   ::Harmony::Pangaea::Client.new(host: :explorer, configuration: configuration).get("tx", parameters: {id: tx_id})
          response && response.success?
        end
        
      end
    end
  end
end
