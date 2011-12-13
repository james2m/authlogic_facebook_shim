require File.expand_path( '../../test_helper.rb', File.dirname(__FILE__) )
require 'koala'

describe AuthlogicFacebookShim::Session::Facebook do

  before do
    activate_authlogic
  end

  describe "setup - for my own sanity" do
    
    before do
      @session = UserSession.new
      override @session, :controller => controller
    end
      
    it "should set the controller" do
      @session.controller.must_equal controller
    end
    
  end
  
  describe "config accessors" do
    
    before do
      @session = UserSession.new
      override @session, :controller => controller
    end
    
    after do
      Object.instance_eval do
        remove_const :User
        remove_const :UserSession
        GC.start
        
        load(File.join(Rails.root, 'app', 'models', 'user.rb'))
        load(File.join(Rails.root, 'app', 'models', 'user_session.rb'))
      end
    end

    it "should return facebook_app_id" do
      mockappid = 'mockappid'
      override UserSession, :facebook_app_id => mockappid
      @session.send(:facebook_app_id).must_equal mockappid
    end

    it "should return facebook_api_key" do
      mockapikey = 'mockapikey'
      override UserSession, :facebook_api_key => mockapikey
      
      @session.send(:facebook_api_key).must_equal mockapikey
    end

    it "should return facebook_secret_key" do
      mocksecret = 'mocksecret'
      override UserSession, :facebook_secret_key => mocksecret
      
      @session.send(:facebook_secret_key).must_equal mocksecret
    end

    it "should return facebook_uid_field" do
      mockuidfield = 'mock_uidfield'
      override UserSession, :facebook_uid_field => mockuidfield
      
      @session.send(:facebook_uid_field).must_equal mockuidfield
    end
    
    describe "facebook_finder" do

      it "should delegate to the class" do
        mockfinder = 'mockfinder'
        override UserSession, :facebook_finder => mockfinder
        
        @session.send(:facebook_finder).must_equal mockfinder
      end

      it "should default if the class returns nil" do
        override UserSession, :facebook_finder => false
        override @session, :facebook_uid_field => 'mock_uidfield'
        
        @session.send(:facebook_finder).must_equal "find_by_mock_uidfield"
      end

    end

    it "should return facebook_auto_register?" do
      override UserSession, :facebook_auto_register => true
      
      @session.send(:facebook_auto_register?).must_equal true
    end

  end
  
  describe "validating with facebook" do
    
    before do
      @session = UserSession.new
      override @session, :controller => controller
    end
    
    describe "with a valid facebook session" do
      
      before do
        @facebook_session = OpenStruct.new(:uid => 'mockuid')

        override @session, :facebook_session? => true
        override @session, :facebook_session => @facebook_session
      end

      describe "with an existing facebook uid" do
      
        before do
          override @session, :facebook_finder => 'finder_method'
        
          @user = User.create
          override User, :finder_method => @user
        
          @session.save
        end
      
        it "should return true for logged_in_with_facebook?" do
          @session.logged_in_with_facebook?.must_equal true
        end
      
        it "should set attempted_record" do
          @session.attempted_record.must_equal @user
        end
      
      end

      describe "without an existing facebook uid" do
        
        before do
          override @session, :facebook_finder => 'finder_method'
          override User, :finder_method => nil
          
          @user = User.new
          override User, :new => @user
        end
      
        describe "and facebook_auto_register? true" do
          
          before do
            override @session, :facebook_auto_register? => true
          end

          it "should build a new user on attempted_record" do
            override User, :new => @user
            
            @session.save
            @session.attempted_record.must_equal @user
          end
        
          it "should attempt to call before_connect on the new user" do
            expect @user, :before_connect, :with => [@facebook_session], :return => true
            assert @session.save
          end
        
          it "should save the new user" do
            expect @user, :save, :with => [:validate => false], :return => true
            assert @session.save
          end
        
        end
      
        describe "and facebook_auto_register? false" do

          it "should return false for logged_in_with_facebook?" do
            override @session, :facebook_auto_register? => false
            @session.save
            
            @session.logged_in_with_facebook?.must_equal false
          end
        
          it "should not set attempted record" do
            override @session, :facebook_auto_register? => false
            
            @session.save

            @session.attempted_record.must_be_nil
          end
        
        end
      
      end

    end

    describe "when skip_facebook_authentication is true" do

      it "should not attempt to validate with facebook" do
        override @session, :skip_facebook_authentication => true
        override @session, :validate_by_facebook => lambda { raise Override::ExpectationError.new('to not be called', 'called') }
        
        @session.save.must_equal false
      end
      
      it "should return false for logged_in_with_facebook?" do
        override @session, :skip_facebook_authentication => true
        
        @session.save.must_equal false
        @session.logged_in_with_facebook?.must_be_nil
      end
      
      it "should not set attempted record" do
        override @session, :skip_facebook_authentication => true

        @session.save.must_equal false
        @session.attempted_record.must_be_nil
      end
    end
    
    describe "when authenticating_with_unauthorized_record? is true" do
      
      before do
        override @session, :facebook_session? => true
        override @session, :authenticating_with_unauthorized_record? => true
      end

      it "should not attempt to validate with facebook" do
        override @session, :validate_by_facebook => lambda { raise Override::ExpectationError.new('to not be called', 'called') }
        
        @session.save.must_equal false
      end

      it "should return false for logged_in_with_facebook?" do
        @session.save.must_equal false
        @session.logged_in_with_facebook?.must_be_nil
      end
      
      it "should not set attempted record" do
        @session.save.must_equal false
        @session.attempted_record.must_be_nil
      end
      
    end
    
  end
  
end
