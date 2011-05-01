module AuthlogicFacebookShim
  module Session  
    module Adapter
      
      # The adapter requires 3 methods;
      #
      # facebook_session should return an OpenStruct or similar object that returns the users
      # uid and access_token when those methods are called.
      # 
      # facebook_session? should just return true if there is a facebook session i.e. the 
      # facebook fbs_FACEBOOK_APP_ID cookie has been set.
      #
      # facebook_user should return an OpenStruct or similar object that returns the users
      # properties by responding to methods of the same name. The one execption to this rule
      # is the facebook property id is replaced with a property uid to aviod clashing with
      # the Object#id method in Ruby.
      #
      # The Facebook user properties are documented here 
      #     http://developers.facebook.com/docs/reference/api/user/


      # The shim chooses which adapter to use by checking for a constant derived from the name
      # of the adapter for example to load the koala_adapter the shim first checks for the 
      # existence of the Koala constant so you need to ensure you load Koala first. Likewise 
      # an adapter for Mogli needs to be called mogli_adapter.rb and Facebooker2 would be 
      # facebooker2_adapter.rb
      Dir[File.expand_path('../adapters/*.rb', File.dirname(__FILE__))].each do |adapter|
        class_name = File.basename(adapter).rpartition(/_adapter\.rb$/).shift.camelize
        if defined?(class_name)
          require adapter
          include AuthlogicFacebookShim::Adapters.const_get("#{class_name}Adapter")
          break
        end
      end
      
    end
  end
end