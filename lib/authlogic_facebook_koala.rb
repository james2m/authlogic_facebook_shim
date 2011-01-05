require 'yaml'
require 'ostruct'
require 'singleton'


if ActiveRecord::Base.respond_to?(:add_acts_as_authentic_module)
  require 'authlogic_facebook_koala/acts_as_authentic'
  require 'authlogic_facebook_koala/session/config'
  require 'authlogic_facebook_koala/session/adapter'
  require 'authlogic_facebook_koala/session/facebook'
  require 'authlogic_facebook_koala/session'
  require 'authlogic_facebook_koala/helper'
  Authlogic::Session::Base.send :include, AuthlogicFacebookKoala::Session
  ActiveRecord::Base.send       :include, AuthlogicFacebookKoala::ActsAsAuthentic
end
