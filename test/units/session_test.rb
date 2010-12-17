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
    
  end
  
end