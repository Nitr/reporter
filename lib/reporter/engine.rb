module Reporter
  class Engine < ::Rails::Engine
    isolate_namespace Reporter

    initializer "reporter.assets.precompile" do |app|
      app.config.assets.precompile += %w( application.css )
    end
  end
end
