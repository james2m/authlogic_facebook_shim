require 'yaml'
require 'ostruct'
require 'singleton'


if ActiveRecord::Base.respond_to?(:add_acts_as_authentic_module)
  require 'authlogic_facebook_shim/acts_as_authentic'
  require 'authlogic_facebook_shim/session/config'
  require 'authlogic_facebook_shim/session/adapter'
  require 'authlogic_facebook_shim/session/facebook'
  require 'authlogic_facebook_shim/session'
  require 'authlogic_facebook_shim/helper'
  Authlogic::Session::Base.send :include, AuthlogicFacebookShim::Session
  ActiveRecord::Base.send       :include, AuthlogicFacebookShim::ActsAsAuthentic
end
