module Harmony
  module Pangaea
    module Network
      class Status
        class << self
          
          def status(format: :json, configuration: ::Harmony::Pangaea.configuration)
            response              =   ::Harmony::Pangaea::Client.new(configuration: configuration).get(path(format))
            data                  =   response&.success? ? parse_response(response, format: format) : nil
          end
          
          def path(format)
            path                  =   case format
              when :text
                "/pga/network"
              when :json
                "/pga/network.json"
              when :csv
                "/pga/network.csv"
              else
                "/pga/network.json"
            end
          end
          
          def parse_response(response, format: :json)
            return case format
              when :text
                ::Harmony::Pangaea::Network::TextParser.new.parse(response)
              when :json
                ::Harmony::Pangaea::Network::JsonParser.new.parse(response)
              when :csv
                ::Harmony::Pangaea::Network::CsvParser.new.parse(response)
              else
                ::Harmony::Pangaea::Network::JsonParser.new.parse(response)
            end
          end
          
        end
      end
    end
  end
end
