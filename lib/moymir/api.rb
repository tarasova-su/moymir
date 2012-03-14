require 'faraday'

module Moymir
  module Api
    class Response
      attr_reader :status, :body, :headers
      
      def initialize(status, body, headers)
        @status  = status
        @body    = body
        @headers = headers
      end
      
      def error?
        body.is_a?(Hash) && body['error'].present?
      end
    end
    
    class Client
      REST_API_URL = "http://www.appsmail.ru/platform/api"
      
      attr_accessor :uid
      
      def initialize(uid)
        self.uid = uid
      end
      
      def call(method, specific_params = {})
        result = make_request(method, specific_params)
        
        raise APIError.new({"type" => "HTTP #{result.status.to_s}", "message" => "Response body: #{result.body}"}) if result.status >= 500
        
        Moymir::Api::Response.new(result.status.to_i, JSON.parse(result.body.to_s), result.headers)
      end
  
      protected
      
        def make_request(method, specific_params)
          params = {
            :method => method,
            :app_id => Moymir::Config.default.app_id,
            :uid    => uid,
            :secure => 1
          }.merge(specific_params)
          
          sig = calculate_signature(params)
          
          Faraday.new(:url => REST_API_URL).get do |request|
            request.params = params.merge(:sig => sig)
          end
        end
        
        def calculate_signature(params)
          param_string = params.sort.map{|key, value| "#{key}=#{value}"}.join
          secret_key = Moymir::Config.default.secret_key
          
          Digest::MD5.hexdigest(param_string + secret_key)
        end
    end
  end
end