module Moymir
  class User
    class << self
      # Creates an instance of Moymir::User using application config and request parameters
      def from_moymir_params(config, params)
        params = decrypt(config, params) if params.is_a?(String)
        
        return if params.nil? || params['vid'].nil? || !signature_valid?(config, params)
        
        new(params)
      end
      
      protected
        def decrypt(config, encrypted_params)
          encryptor = ActiveSupport::MessageEncryptor.new(config.secret_key)
          
          encryptor.decrypt_and_verify(encrypted_params)
        rescue ActiveSupport::MessageEncryptor::InvalidMessage
          nil
        end      
        
        def signature_valid?(config, params)
          param_string = params.except('sig').sort.map{|key, value| "#{key}=#{value}"}.join
          secret_key   = config.secret_key
          
          params['sig'] == Digest::MD5.hexdigest(param_string + secret_key)
        end
    end

    def initialize(options = {})
      @options = options
    end

    # Checks if user is authenticated in the application
    def authenticated?      
      !session_key.blank? && Time.now < session_expires_at
    end

    # Mailru UID
    def uid
      @options['vid']
    end
    
    def session_key
      @options['session_key']
    end
    
    def session_expires_at
      Time.at(@options['session_expire'].to_i)
    end
    
    def is_app_user
      @options['is_app_user']
    end
    
    def permissions
      @options['ext_perm'].split(',')
    end
    
    # mail.ru API client instantiated with user id
    def api_client
      @api_client ||= Moymir::Api::Client.new(uid)
    end
  end

end