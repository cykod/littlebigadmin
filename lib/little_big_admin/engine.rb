module LittleBigAdmin
  class Engine < ::Rails::Engine
    isolate_namespace LittleBigAdmin

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

    initializer 'littlebigadmin.assets.precompile' do |app|
      app.config.assets.precompile <<  %w( little_big_admin/navigation-expand-target.png )
    end
  end
end
