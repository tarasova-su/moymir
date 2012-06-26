require 'moymir/rails/controller/url_rewriting'
require 'moymir/rails/controller/redirects'

module Moymir
  module Rails

    module Controller
      def self.included(base)
        base.class_eval do
          include Moymir::Rails::Controller::UrlRewriting
          include Moymir::Rails::Controller::Redirects

          # Fix cookie permission issue in IE
          before_filter :normal_cookies_for_ie_in_iframes!

          helper_method(:moymir, :moymir_params, :signed_params, :current_moymir_user, :params_without_moymir_data)

          helper Moymir::Rails::Helpers
        end
      end

      protected

      MOYMIR_PARAM_NAMES = %w{app_id session_key session_expire oid vid is_app_user ext_perm window_id view referer_type referer_id authentication_key sig ref_notify }

      # Accessor to current application config. Override it in your controller
      # if you need multi-application support or per-request configuration selection.
      def moymir
        Moymir::Config.default
      end

      # Accessor to current Moymir user. Returns instance of Moymir::User
      def current_moymir_user
        @current_moymir_user ||= fetch_current_moymir_user
      end

      # A hash of params passed to this action, excluding secure information passed by Moymir
      def params_without_moymir_data
        params.except(*MOYMIR_PARAM_NAMES)
      end

      # params coming directly from moymir
      def moymir_params
        params.slice(*MOYMIR_PARAM_NAMES)
      end
      
      # encrypted moymir params
      def signed_params
        if moymir_params['session_key'].present?
          encrypt(moymir_params)
        else
          request.env["HTTP_SIGNED_PARAMS"] || request.params['signed_params'] || flash['signed_params']
        end
      end

      private

        def fetch_current_moymir_user
          Moymir::User.from_moymir_params(moymir, moymir_params['session_key'].present? ? moymir_params : signed_params)
        end
        
        def encrypt(params)
          encryptor = ActiveSupport::MessageEncryptor.new(moymir.secret_key)
          
          encryptor.encrypt_and_sign(params)
        end
    end

  end
end