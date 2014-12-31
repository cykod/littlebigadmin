require 'jquery-rails'

require "little_big_admin/base"
require "little_big_admin/view_builder"
require "little_big_admin/table_builder"

require "little_big_admin/config"
require "little_big_admin/engine"

require "little_big_admin/registrar"

require "little_big_admin/model"
require "little_big_admin/page"
require "little_big_admin/graph"

module LittleBigAdmin

  mattr_accessor :config
  mattr_accessor :objects

  def self.model(name, options = {}, &block)
    LittleBigAdmin::Registrar.register(:model, name, options, &block)
  end

  def self.graph(name, options = {}, &block)
    LittleBigAdmin::Registrar.register(:graph, name, options, &block)
  end

  def self.page(name, options = {}, &block)
    LittleBigAdmin::Registrar.register(:page, name, options, &block)
  end

  def self.setup(&block)
    reset
    self.config = LittleBigAdmin::Config.new
    self.config.run(&block)

    ActiveSupport::Dependencies.autoload_paths -= self.config.load_paths

    load_all_objects
  end

  def self.reset
    self.config = nil
    self.objects = nil
  end

  def self.load_all_objects
    admin_files.each { |file| load(file) }
  end

  def self.admin_files
    self.config.load_paths.map{ |path| Dir["#{path}/**/*.rb"] }.flatten
  end

end
