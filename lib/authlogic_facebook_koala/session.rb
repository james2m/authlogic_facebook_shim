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
        rw_config(:facebook_finder, value, nil)
      end
      alias_method :facebook_finder=, :facebook_finder

      # What extended permissions should be requested from the user?
      #
      # * <tt>Default:</tt> []
      # * <tt>Accepts:</tt> Array of Strings
      def facebook_permissions(value=nil)
        rw_config(:facebook_permissions, value, [])
      end
      alias_method :facebook_permissions=, :facebook_permissions

      # Should a new user be automatically created if there is no user with
      # given facebook uid?
      #
      # * <tt>Default:</tt> false
      # * <tt>Accepts:</tt> Boolean
      def facebook_auto_register(value=true)
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
      
      def facebook_session?
        @logged_in_with_facebook
      end

      protected
      # Override this if you want only some requests to use facebook
      def authenticating_with_facebook?
        !authenticating_with_unauthorized_record? &&
          !self.class.facebook_app_id.blank? &&
          !self.class.facebook_secret_key.blank?
      end

      # TODO - just for the moment, make these private when we've worked out what to do with facebook_session
      # private
      
      def validate_by_facebook
        facebook_uid = facebook_session['uid']
        self.attempted_record = klass.send(facebook_finder, facebook_uid)

        if self.attempted_record || !facebook_auto_register?
          return @logged_in_with_facebook = !!self.attempted_record
        else
          self.attempted_record = klass.new
          self.attempted_record.send(:"#{facebook_uid_field}=", facebook_uid)
          if self.attempted_record.respond_to?(:before_connect)
            self.attempted_record.send(:before_connect, facebook_session)
          end

          return @logged_in_with_facebook = self.attempted_record.save(false)
        end
      end

      def facebook_session
        return @facebook_session if defined?(@facebook_session)
        access_token = unverified_facebook_params['access_token']
        
        # Make sure these are valid credentials
        graph = Koala::Facebook::GraphAPI.new(access_token)
        uid = nil
        
        4.times do
          begin
            uid = graph.get_object('me')['id']
            break
          rescue Errno::ECONNRESET, EOFError, Timeout::Error => e
            exception = e
          end
        end

        raise exception if !uid

        @facebook_session = {'uid' => uid, 'access_token' => access_token}
      end

      def unverified_facebook_params
        return @unverified_facebook_params if defined?(@unverified_facebook_params)
        
        oauth = Koala::Facebook::OAuth.new(self.class.facebook_app_id, self.class.facebook_secret_key)

        params = oauth.get_user_from_cookie(controller.cookies)

        @unverified_facebook_params = params.is_a?(Hash) ? params : {}
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
end
