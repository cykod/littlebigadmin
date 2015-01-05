$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "little_big_admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "littlebigadmin"
  s.version     = LittleBigAdmin::VERSION
  s.authors     = ["Pascal Rettig"]
  s.email       = ["pascal@cykod.com"]
  s.homepage    = "https://github.com/cykod/LittleBigAdmin"
  s.summary     = "LittleBigAdmin."
  s.description = "LittleBigAdmin."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency "jquery-rails"

  s.add_development_dependency "pg"
  s.add_development_dependency "paperclip"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'byebug'
end
