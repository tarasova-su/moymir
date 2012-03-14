if Rails::VERSION::MAJOR > 2

  module Moymir
    class Engine < ::Rails::Engine
      initializer "moymir.middleware" do |app|
        app.middleware.insert_after(ActionDispatch::ParamsParser, Moymir::Rack::PostCanvasMiddleware)
      end

      initializer "moymir.controller_extension" do
        ActiveSupport.on_load :action_controller do
          ActionController::Base.send(:include, Moymir::Rails::Controller)
        end
      end
    end
  end

else

  ActionController::Dispatcher.middleware.insert_after(ActionController::ParamsParser, Moymir::Rack::PostCanvasMiddleware)

  ActionController::Base.send(:include, Moymir::Rails::Controller)

  # Loading plugin controllers manually because the're not loaded automatically from gems
  Dir[File.expand_path('../../../app/controllers/**/*.rb', __FILE__)].each do |file|
    require file
  end
end
