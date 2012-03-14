require 'moymir/rails/helpers/url_helper'

module Moymir
  module Rails
    module Controller
      module UrlRewriting
        include Moymir::Rails::Helpers::UrlHelper

        def self.included(base)
          base.class_eval do
            helper_method(:moymir_canvas_page_url, :moymir_callback_url)
          end
        end

        protected

        # A helper to generate an URL of the application canvas page URL
        #
        # @param protocol A request protocol, should be either 'http://' or 'https://'.
        #                 Defaults to current protocol.
        def moymir_canvas_page_url(protocol = nil)
          moymir.canvas_page_url(protocol || request.protocol)
        end

        # A helper to generate an application callback URL
        #
        # @param protocol A request protocol, should be either 'http://' or 'https://'.
        #                 Defaults to current protocol.
        def moymir_callback_url(protocol = nil)
          moymir.callback_url(protocol || request.protocol)
        end
      end
    end
  end
end
