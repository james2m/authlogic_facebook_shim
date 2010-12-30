module AuthlogicFacebookKoala
  module Session
    
    def self.included(klass)
      
      klass.class_eval do
        attr_accessor :skip_facebook_authentication
        validate :validate_by_facebook, :if => :authenticating_with_facebook?
      end
      
    end
      
    def logged_in_with_facebook?
      @logged_in_with_facebook
    end

    protected
    # Override this if you want only some requests to use facebook
    def authenticating_with_facebook?
      !skip_facebook_authentication && !authenticating_with_unauthorized_record? && facebook_session?
    end

    private
    
    def validate_by_facebook
      facebook_uid = facebook_session.uid
      self.attempted_record = klass.send(facebook_finder, facebook_uid)

      if self.attempted_record || !facebook_auto_register?
        return @logged_in_with_facebook = !!self.attempted_record
      else
        self.attempted_record = klass.new
        self.attempted_record.send(:"#{facebook_uid_field}=", facebook_uid)
        if self.attempted_record.respond_to?(:before_connect)
          self.attempted_record.send(:before_connect, facebook_session)
        end

        @logged_in_with_facebook = true
        return self.attempted_record.save(false)
      end
    end
    
    def facebook_app_id
      self.class.facebook_app_id
    end
    
    def facebook_api_key
      self.class.facebook_api_key
    end
    
    def facebook_secret_key
      self.class.facebook_secret_key
    end

    def facebook_auto_register?
      self.class.facebook_auto_register
    end

    def facebook_uid_field
      self.class.facebook_uid_field
    end

    def facebook_finder
      self.class.facebook_finder || "find_by_#{facebook_uid_field}"
    end
      
  end
end
