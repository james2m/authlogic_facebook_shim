module AuthlogicFacebookKoala
  module Session
    
    def self.included(klass)
      klass.extend Session::Config      
      klass.send(:include, Session::Adapter)
      klass.send(:include, Session::Facebook)
    end
    
  end
end
      