require File.expand_path( '../../test_helper.rb', File.dirname(__FILE__) )

describe AuthlogicFacebookShim::Session::Config do
    
  before do
    @session_class = Class.new(Authlogic::Session::Base)
  end

  describe "facebook_config_file" do

    it "should have a default 'facebook.yml'" do
      @session_class.facebook_config_file.must_equal 'facebook.yml'
    end
    
    it "should have a setter method" do
      fb_config = 'fbconf.yml'
      @session_class.facebook_config_file = fb_config
      @session_class.facebook_config_file.must_equal fb_config
    end
    
  end
  
  describe "facebook_app_id" do

    it "should default to default_config.app_id" do
      default_from_config = 'defaultappid'
      
      expect @session_class.default_config, 'app_id', :with => [], :return => default_from_config
      
      @session_class.facebook_app_id.must_equal default_from_config
    end
    
    it "should have a setter method" do
      fb_app_id = '234234234'
      @session_class.facebook_app_id = fb_app_id
      @session_class.facebook_app_id.must_equal fb_app_id
    end
    
  end

  describe "facebook_secret_key" do

    it "should default to default_config.secret_key" do
      default_from_config = 'defaultsecretkey'
      
      expect @session_class.default_config, 'secret_key', :with => [], :return => default_from_config
      
      @session_class.facebook_secret_key.must_equal default_from_config
    end
    
    it "should have a setter method" do
      fb_secret = '553246736447566b583138525a716e693950736'
      @session_class.facebook_secret_key = fb_secret
      @session_class.facebook_secret_key.must_equal fb_secret
    end
    
  end
  
  describe "facebook_api_key" do

    it "should default to default_config.api_key" do
      default_from_config = 'defaultapikey'
      
      expect @session_class.default_config, 'api_key', :with => [], :return => default_from_config
      
      @session_class.facebook_api_key.must_equal default_from_config
    end
    
    it "should have a setter method" do
      fb_api_key = '25a366a46366451636933676978776a45585734'
      @session_class.facebook_api_key = fb_api_key
      @session_class.facebook_api_key.must_equal fb_api_key
    end
    
  end
  
  describe "facebook_uid_field" do

    it "should have a default of :facebook_uid" do
      @session_class.facebook_uid_field.must_equal :facebook_uid
    end
    
    it "should have a setter method" do
      fb_uid_field = 'fb_uid'
      @session_class.facebook_uid_field = fb_uid_field
      @session_class.facebook_uid_field.must_equal fb_uid_field
    end
    
  end
  
  describe "facebook_finder" do

    it 'should default to false' do
      @session_class.facebook_finder.must_equal false
    end
    
    it "should have a setter method" do
      fb_finder = 'find_by_fb_uid'
      @session_class.facebook_finder = fb_finder
      @session_class.facebook_finder.must_equal fb_finder
    end
    
  end
  
  describe "facebook_auto_register" do

    it 'should have a default false' do
      @session_class.facebook_auto_register.must_equal false
    end
    
    it "should have a setter method" do
      fb_auto_reg = true
      @session_class.facebook_auto_register = fb_auto_reg
      @session_class.facebook_auto_register.must_equal fb_auto_reg
    end
    
  end

  describe "default_config" do

    it "should be a class method" do
      @session_class.must_respond_to :default_config
    end
    
    it "should return an OpenStruct" do
      @session_class.default_config.must_be_instance_of OpenStruct
    end
    
    it "should return the app_id from the default config file" do
      @session_class.default_config.app_id.must_equal 'appidfromfile'
    end
    
    it "should return the api_key from the default config file" do
      @session_class.default_config.api_key.must_equal 'apikeyfromfile'
    end
    
    it "should return the secret_key from the default config file" do
      @session_class.default_config.secret_key.must_equal 'secretkeyfromfile'
    end

    it "should return an empty OpenStruct if the file isn't found" do
      expect @session_class, :facebook_config_file, :with => [], :return => 'notthere.yml'
      @session_class.default_config.must_equal OpenStruct.new({})
    end
  end
  
end