require 'jquery-rails'
require 'turbolinks'
require "little_big_admin/engine"

require "little_big_admin/base"
require "little_big_admin/view_builder"
require "little_big_admin/table_builder"
require "little_big_admin/form_builder"
require "little_big_admin/graph_builder"
require "little_big_admin/metrics_builder"

require "little_big_admin/formatter"
require "little_big_admin/formatters/default"
require "little_big_admin/formatters/date"
require "little_big_admin/formatters/model"
require "little_big_admin/formatters/numeric"
require "little_big_admin/formatters/currency"
require "little_big_admin/formatters/percent"

require "little_big_admin/config"

require "little_big_admin/registrar"

require "little_big_admin/model"
require "little_big_admin/page"
require "little_big_admin/graph"

require "little_big_admin/item_list"
require "little_big_admin/restful_model"
require "little_big_admin/model_viewer"

module LittleBigAdmin

  mattr_accessor :config
  mattr_accessor :objects

  def self.model(name, options = {}, &block)
    LittleBigAdmin::Registrar.register(:model, name, options, &block)
  end

  def self.model_for(object)
    cls = object.class.to_s.underscore
    model = LittleBigAdmin::Registrar.get(:model, cls)
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

    Time::DATE_FORMATS[:little_big_admin_date] = LittleBigAdmin.config.date_format
    Time::DATE_FORMATS[:little_big_admin_time] = LittleBigAdmin.config.time_format  

    LittleBigAdmin::ViewBuilder.send(:include, Rails.application.routes.url_helpers)

    Rails.application.config.assets.precompile += %w( little_big_admin_application.js little_big_admin_application.css )
    load_all_objects
  end

  def self.reset
    self.config = nil
  end

  def self.load_all_objects
    self.objects = nil
    admin_files.each { |file| load(file) }
  end

  def self.admin_files
    self.config.load_paths.map{ |path| Dir["#{path}/**/*.rb"] }.flatten
  end

end
