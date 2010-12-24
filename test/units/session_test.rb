require File.expand_path( '../test_helper.rb', File.dirname(__FILE__) )

class SessionTest < ActiveSupport::TestCase

  context "Config" do
    
    setup do
      @session_class = Class.new(Authlogic::Session::Base)
    end

    context "facebook_app_id" do

      should "have a default nil" do
        assert_nil @session_class.facebook_app_id
      end
      
      should "have a setter method" do
        fb_app_id = '234234234'
        @session_class.facebook_app_id = fb_app_id
        assert_equal fb_app_id, @session_class.facebook_app_id
      end
      
    end

    context "facebook_secret_key" do

      should "have a default nil" do
        assert_nil @session_class.facebook_secret_key
      end
      
      should "have a setter method" do
        fb_secret = '553246736447566b583138525a716e693950736'
        @session_class.facebook_secret_key = fb_secret
        assert_equal fb_secret, @session_class.facebook_secret_key
      end
      
    end
    
    context "facebook_api_key" do

      should "have a default nil" do
        assert_nil @session_class.facebook_api_key
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

      should 'have a default find_by_#{facebook_uid_field}' do
        assert_equal 'find_by_#{facebook_uid_field}', @session_class.facebook_finder
      end
      
      should "have a setter method" do
        fb_finder = 'find_by_fb_uid'
        @session_class.facebook_finder = fb_finder
        assert_equal fb_finder, @session_class.facebook_finder
      end
      
    end
    
    
  end
  
end