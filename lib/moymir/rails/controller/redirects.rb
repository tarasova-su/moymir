module Moymir
  module Rails
    module Controller
      module Redirects
        def self.included(base)
          base.class_eval do
            alias_method_chain :redirect_to, :moymir_params
          end
        end

        protected

        # Overrides ActionController::Base#redirect_to to pass signed_request in flash[]
        def redirect_to_with_moymir_params(*args)
          flash['signed_params'] = signed_params

          redirect_to_without_moymir_params(*args)
        end

        # Redirects user to a definite URL with JavaScript code that overwrites
        # top frame location. Use it to redirect user from within an iframe.
        
        # FIXME in Moymir apps, params should go to hash!
        # only redirect_from_iframe root_url(:canvas => true) works properly now
        
        def redirect_from_iframe(url_options)
          redirect_url = url_options.is_a?(String) ? url_options : url_for(url_options)

          logger.info "Redirecting from IFRAME to #{ redirect_url }"
          
          respond_to do |format|
            format.html do
              render(
                :text   => iframe_redirect_html_code(redirect_url),
                :layout => false
              )
            end
            
            format.js do
              render(
                :text   => iframe_redirect_js_code(redirect_url),
                :layout => false
              )
            end
          end
        end

        # Generates HTML and JavaScript code to redirect user with top frame location
        # overwrite
        #
        # @param target_url   An URL to redirect the user to
        # @param custom_code  A custom HTML code to insert into the result document.
        #                     Can be used to add OpenGraph tags to redirect page code.
        def iframe_redirect_html_code(target_url, custom_code = nil)
          %{
            <html><head>
              <script type="text/javascript">
                window.top.location.href = #{ target_url.to_json };
              </script>
              <noscript>
                <meta http-equiv="refresh" content="0;url=#{ target_url }" />
                <meta http-equiv="window-target" content="_top" />
              </noscript>
              #{ custom_code }
            </head></html>
          }
        end
        
        # Generates JavaScript code to redirect user
        #
        # @param target_url   An URL to redirect the user to
        def iframe_redirect_js_code(target_url)
          "window.top.location.href = #{ target_url.to_json };"
        end
      end
    end
  end
end