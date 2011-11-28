require 'authlogic_facebook_shim/version'
require 'yaml'
require 'ostruct'
require 'singleton'

module AuthlogicFacebookShim
  autoload :ActsAsAuthentic,    'authlogic_facebook_shim/acts_as_authentic'
  autoload :Session,            'authlogic_facebook_shim/session'
end

require 'authlogic_facebook_shim/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3
