module Moymir
  module Rails
    module Helpers
      module JavascriptHelper
        # A helper to integrate Moymir Connect to the current page. Generates a
        # JavaScript code that initializes Javascript client for the
        # current application.
        #
        # @param app_id   Private App ID of the application. Defaults to value provided by the current config.
        # @param &block   A block of JS code to be inserted in addition to client initialization code.
        def mm_connect_js(*args, &block)
          options = args.extract_options!
      
          private_key  = args.shift || moymir.private_key
      
          extra_js = capture(&block) if block_given?
      
          init_js = <<-JAVASCRIPT
            mailru.app.init('#{ private_key }');
          JAVASCRIPT
      
          js_url = "cdn.connect.mail.ru/js/loader.js"
      
          js = <<-CODE
            <script src="#{ request.protocol }#{ js_url }" type="text/javascript"></script>
          CODE
      
          js << <<-CODE
            <script type="text/javascript">
              if(typeof mailru !== 'undefined') {
                mailru.loader.require('api', function() {
                  #{init_js}
                  #{extra_js}
                });
              }
            </script>
          CODE
      
          js = js.html_safe
      
          if block_given? && ::Rails::VERSION::STRING.to_i < 3
            concat(js)
          else
            js
          end
        end
      end
    end
  end
end
