module Moymir
  # Moymir application configuration class
  class Config
    attr_accessor :config

    class << self
      def default
        @@default ||= self.new(load_default_config_from_file)
      end

      def load_default_config_from_file
        config_data = YAML.load(
          ERB.new(
            File.read(::Rails.root.join("config", "moymir.yml"))
          ).result
        )[::Rails.env]

        raise NotConfigured.new("Unable to load configuration for #{ ::Rails.env } from config/moymir.yml") unless config_data

        config_data
      end
    end

    def initialize(options = {})
      self.config = options.to_options
    end

    # Defining methods for quick access to config values
    %w{app_id private_key secret_key namespace callback_domain}.each do |attribute|
      class_eval %{
        def #{ attribute }
          config[:#{ attribute }]
        end
      }
    end

    def canvas_page_url(protocol)
      "#{ protocol }my.mail.ru/apps/#{ app_id }"
    end

    # Application callback URL
    def callback_url(protocol)
      protocol + callback_domain
    end
  end
end