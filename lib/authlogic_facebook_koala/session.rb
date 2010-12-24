module AuthlogicFacebookKoala
  module Session
    def self.included(klass)
      klass.class_eval do
        extend Config
        include Methods
      end
    end

    module Config
      # REQUIRED
      #
      # Specify your app_id.
      #
      # * <tt>Default:</tt> nil
      # * <tt>Accepts:</tt> String
      def facebook_app_id(value=nil)
        rw_config(:facebook_app_id, value, nil)
      end
      alias_method :facebook_app_id=, :facebook_app_id

      # REQUIRED
      #
      # Specify your secret_key.
      #
      # * <tt>Default:</tt> nil
      # * <tt>Accepts:</tt> String
      def facebook_secret_key(value=nil)
        rw_config(:facebook_secret_key, value, nil)
      end
      alias_method :facebook_secret_key=, :facebook_secret_key

      # Specify your api_key.
      #
      # * <tt>Default:</tt> nil
      # * <tt>Accepts:</tt> String
      def facebook_api_key(value=nil)
        rw_config(:facebook_api_key, value, nil)
      end
      alias_method :facebook_api_key=, :facebook_api_key

      # What user field should be used for the facebook UID?
      #
      # * <tt>Default:</tt> :facebook_uid
      # * <tt>Accepts:</tt> Symbol
      def facebook_uid_field(value=nil)
        rw_config(:facebook_uid_field, value, :facebook_uid)
      end
      alias_method :facebook_uid_field=, :facebook_uid_field

      # What method should be used to find the facebook account?
      #
      # * <tt>Default:</tt> :find_by_#{facebook_uid_field}
      # * <tt>Accepts:</tt> Symbol or String
      def facebook_finder(value=nil)
        rw_config(:facebook_finder, value, 'find_by_#{facebook_uid_field}')
      end
      alias_method :facebook_finder=, :facebook_finder

      # Should a new user be automatically created if there is no user with
      # given facebook uid?
      #
      # * <tt>Default:</tt> false
      # * <tt>Accepts:</tt> Boolean
      def facebook_auto_register(value=nil)
        rw_config(:facebook_auto_register, value, false)
      end
      alias_method :facebook_auto_register=, :facebook_auto_register
    end

    module Methods
      def self.included(klass)
        klass.class_eval do
          validate :validate_by_facebook, :if => :authenticating_with_facebook?
        end
      end
      
      def logged_in_with_facebook?
        @logged_in_with_facebook
      end

      protected
      # Override this if you want only some requests to use facebook
      def authenticating_with_facebook?
        if controller.respond_to?(:controller) && controller.controller.respond_to?(:set_facebook_session)
          controller.set_facebook_session
          !authenticating_with_unauthorized_record? && controller.facebook_session?
        end
      end

      private
      
      def validate_by_facebook
        puts "validating with facebook"
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

      def facebook_user
        controller.facebook_user
      end

      def facebook_session
        controller.facebook_session
      end

      def facebook_auto_register?
        self.class.facebook_auto_register
      end

      def facebook_uid_field
        self.class.facebook_uid_field
      end

      def facebook_finder
        instance_eval(self.class.facebook_finder)
      end

    end
  end
end
