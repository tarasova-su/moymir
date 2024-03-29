module Moymir
  module Rails
    module Helpers
	    module UrlHelper
        # Overrides UrlHelper#url_for to filter out secure params
        # and add Moymir Canvas URL if necessary
        def url_for(options = {})
          if options.is_a?(Hash)
            if options.delete(:canvas) && !options[:host]
              options[:only_path] = true

              canvas = true
            else
              canvas = false
            end

            url = super(options.except(:signed_params))

            canvas ? moymir_canvas_page_url + url : url
          else
            super
          end
        end
      end
    end
  end
end
