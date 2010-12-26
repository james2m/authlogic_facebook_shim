module AuthlogicFacebookKoala
  
  module Config

    def self.extended(klass)
      (class << klass; self end).send(:define_method, :default_config) do
        @default_config ||= begin
          config_file = File.join(Rails.root, 'config', facebook_config_file)
          OpenStruct.new(File.exist?(config_file) ? YAML.load_file(config_file)[Rails.env] : {})
        end
      end
    end
    
    # Specify your config file if using one. If not then you need to specify
    # facebook_app_id, facebook_secret_key & facebook_api_key
    #
    # * <tt>Default:</tt> facebook.yml
    # * <tt>Accepts:</tt> String
    def facebook_config_file(value=nil)
      rw_config(:facebook_config_file, value, 'facebook.yml')
    end
    alias_method :facebook_config_file=, :facebook_config_file

    # Specify your app_id.
    #
    # * <tt>Default:</tt> app_id in config/facebook.yml
    # * <tt>Accepts:</tt> String
    def facebook_app_id(value=nil)
      rw_config(:facebook_app_id, value, default_config.app_id)
    end
    alias_method :facebook_app_id=, :facebook_app_id

    # Specify your secret_key.
    #
    # * <tt>Default:</tt> secret_key in config/facebook.yml
    # * <tt>Accepts:</tt> String
    def facebook_secret_key(value=nil)
      rw_config(:facebook_secret_key, value, default_config.secret_key)
    end
    alias_method :facebook_secret_key=, :facebook_secret_key

    # Specify your api_key.
    #
    # * <tt>Default:</tt> api_key in config/facebook.yml
    # * <tt>Accepts:</tt> String
    def facebook_api_key(value=nil)
      rw_config(:facebook_api_key, value, default_config.api_key)
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
    
end