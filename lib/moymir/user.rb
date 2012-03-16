module Moymir
  class User
    class << self
      # Creates an instance of Moymir::User using application config and request parameters
      def from_request(options)
        return if options.nil? || options['vid'].nil?
        
        new(options)
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