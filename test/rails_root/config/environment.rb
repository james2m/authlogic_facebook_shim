RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  # config.active_record.schema_format = :sql
  
  config.gem "authlogic"
  config.gem "koala"
  config.gem "test-unit", :lib => "test/unit"
  config.gem "shoulda"
  
  config.frameworks -= [ :active_resource, :action_mailer ]
  config.log_level = :debug
  config.cache_classes = false
  config.whiny_nils = true
  config.action_controller.consider_all_requests_local = true
  config.action_controller.perform_caching             = false
  config.action_view.cache_template_loading            = true
  config.action_controller.allow_forgery_protection    = false
  config.action_mailer.delivery_method = :test
  config.time_zone = 'UTC'

end