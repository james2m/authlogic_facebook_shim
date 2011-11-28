require 'authlogic_facebook_shim'
require 'rails'

module AuthlogicFacebookShim
  class Railtie < Rails::Railtie
    
    initializer "authlogic_facebook_shim.active_record" do |app|
      ActiveSupport.on_load :active_record do

        if respond_to?(:add_acts_as_authentic_module)
          Authlogic::Session::Base.send :include, AuthlogicFacebookShim::Session
          include AuthlogicFacebookShim::ActsAsAuthentic
        end

      end
    end
    
  end
end