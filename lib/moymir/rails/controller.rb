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

          helper_method(:moymir, :moymir_params, :current_moymir_user, :params_without_moymir_data)

          helper Moymir::Rails::Helpers
        end
      end

      protected

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
        params.except(:vid, :session_key, :session_expire, :ext_perm, :sig)
      end

      def moymir_params
        {}.tap do |params|
          %w{vid session_key session_expire ext_perm sig}.each do |attr|
            params[attr] = request.env["HTTP_#{attr.upcase}"] || request.params[attr] || flash[attr]
          end
        end
      end

      private

      def fetch_current_moymir_user
        Moymir::User.from_request(moymir, moymir_params) # || Moymir::User.from_cookie(moymir, moymir_cookie) 
      end
    end

  end
end