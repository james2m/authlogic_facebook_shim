module AuthlogicFacebookShim
  module Session
    
    autoload :Config,    'authlogic_facebook_shim/session/config'
    autoload :Adapter,   'authlogic_facebook_shim/session/adapter'
    autoload :Facebook,  'authlogic_facebook_shim/session/facebook'
       
    def self.included(klass)
      klass.extend Session::Config      
      klass.send(:include, Session::Adapter)
      klass.send(:include, Session::Facebook)
    end
    
  end
end
      