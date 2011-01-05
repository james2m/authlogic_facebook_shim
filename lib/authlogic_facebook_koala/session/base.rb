module Authlogic
  module Session
    class Base
      extend AuthlogicFacebookKoala::Session::Config      
      include AuthlogicFacebookKoala::Session::Adapter
      include AuthlogicFacebookKoala::Session::Facebook
    end
  end
end
      