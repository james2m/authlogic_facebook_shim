require File.expand_path( '../test_helper.rb', File.dirname(__FILE__) )

class ConfigTest < ActiveSupport::TestCase

  context "Config" do
    
    setup do
      @session_class = Class.new(Authlogic::Session::Base)
    end

    context "facebook_config_file" do

      should "have a default 'facebook.yml'" do
        assert_equal 'facebook.yml', @session_class.facebook_config_file
      end
      
      should "have a setter method" do
        fb_config = 'fbconf.yml'
        @session_class.facebook_config_file = fb_config
        assert_equal fb_config, @session_class.facebook_config_file
      end
      
    end
    
    context "facebook_app_id" do

      should "default to default_config.app_id" do
        default_from_config = 'defaultappid'
        flexmock(@session_class).should_receive('default_config.app_id').and_return(default_from_config).once
        assert_equal default_from_config, @session_class.facebook_app_id
      end
      
      should "have a setter method" do
        fb_app_id = '234234234'
        @session_class.facebook_app_id = fb_app_id
        assert_equal fb_app_id, @session_class.facebook_app_id
      end
      
    end

    context "facebook_secret_key" do

      should "default to default_config.secret_key" do
        default_from_config = 'defaultsecretkey'
        flexmock(@session_class).should_receive('default_config.secret_key').and_return(default_from_config).once
        assert_equal default_from_config, @session_class.facebook_secret_key
      end
      
      should "have a setter method" do
        fb_secret = '553246736447566b583138525a716e693950736'
        @session_class.facebook_secret_key = fb_secret
        assert_equal fb_secret, @session_class.facebook_secret_key
      end
      
    end
    
    context "facebook_api_key" do

      should "default to default_config.api_key" do
        default_from_config = 'defaultapikey'
        flexmock(@session_class).should_receive('default_config.api_key').and_return(default_from_config).once
        assert_equal default_from_config, @session_class.facebook_api_key
      end
      
      should "have a setter method" do
        fb_api_key = '25a366a46366451636933676978776a45585734'
        @session_class.facebook_api_key = fb_api_key
        assert_equal fb_api_key, @session_class.facebook_api_key
      end
      
    end
    
    context "facebook_uid_field" do

      should "have a default of :facebook_uid" do
        assert_equal :facebook_uid, @session_class.facebook_uid_field
      end
      
      should "have a setter method" do
        fb_uid_field = 'fb_uid'
        @session_class.facebook_uid_field = fb_uid_field
        assert_equal fb_uid_field, @session_class.facebook_uid_field
      end
      
    end
    
    context "facebook_finder" do

      should 'have a default nil' do
        assert_nil @session_class.facebook_finder
      end
      
      should "have a setter method" do
        fb_finder = 'find_by_fb_uid'
        @session_class.facebook_finder = fb_finder
        assert_equal fb_finder, @session_class.facebook_finder
      end
      
    end
    
    context "facebook_auto_register" do

      should 'have a default false' do
        assert_false @session_class.facebook_auto_register
      end
      
      should "have a setter method" do
        fb_auto_reg = true
        @session_class.facebook_auto_register = fb_auto_reg
        assert_equal fb_auto_reg, @session_class.facebook_auto_register
      end
      
    end

    context "default_config" do

      should "be a class method" do
        assert @session_class.respond_to?(:default_config)
      end
      
      should "return an OpenStruct" do
        assert @session_class.default_config.is_a?(OpenStruct)
      end
      
      should "return the app_id from the default config file" do
        assert_equal 'appidfromfile', @session_class.default_config.app_id
      end
      
      should "return the api_key from the default config file" do
        assert_equal 'apikeyfromfile', @session_class.default_config.api_key
      end
      
      should "return the secret_key from the default config file" do
        assert_equal 'secretkeyfromfile', @session_class.default_config.secret_key
      end

      should "return an empty OpenStruct if the file isn't found" do
        flexmock(@session_class).should_receive(:facebook_config_file).and_return('notthere.yml').once
        assert_equal OpenStruct.new({}), @session_class.default_config
      end
    end
    
  end
  
end