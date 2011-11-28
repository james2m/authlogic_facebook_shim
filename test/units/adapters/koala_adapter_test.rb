require File.expand_path('../../../test_helper', __FILE__)
require 'koala'

describe AuthlogicFacebookShim::Adapters::KoalaAdapter do
  
  before do
    activate_authlogic
    
    @user_info = {
      'session_key'  => 'mocksessionkey',
      'expires'      => '0',
      'uid'          => 'mockuid',
      'sig'          => 'cbd80b97f124bf392f76e2ee61168990',
      'secret'       => 'mocksecret',
      'access_token' => 'mockaccesstoken'
    }
    
    @mock_cookies = MockCookieJar.new
    @mock_cookies['fbs_mockappid'] = { 
      :value => 'access_token=mockaccesstoken&expires=0&secret=mocksecret&session_key=mocksessionkey&sig=cbd80b97f124bf392f76e2ee61168990&uid=mockuid'
    }
    
    override controller, :cookies => @mock_cookies
    
    @session = UserSession.new
    override @session, :facebook_app_id     => 'mockappid'
    override @session, :facebook_api_key    => 'mockapikey'
    override @session, :facebook_secret_key => 'mocksecret'
  end

  describe "setup - for my own sanity" do
      
    it "should set the controller" do
      @session.send(:controller).must_equal controller
    end
    
    it "should set the cookies" do
      @session.send(:controller).cookies.must_equal @mock_cookies
    end
    
    it "should set the facebook_app_id" do
      @session.facebook_app_id.must_equal 'mockappid'
    end
    
    it "should set the facebook_secret_key" do
      @session.facebook_secret_key.must_equal 'mocksecret' 
    end
    
    it "should set the facebook_api_key" do
      @session.facebook_api_key.must_equal 'mockapikey' 
    end
    
  end
  
  describe "facebook_session" do
  
    describe "with a valid facebook cookie" do
      
      describe "and koala support for get_user_info_from_cookie" do
  
        it "should return a session_key" do
          @session.facebook_session.session_key.must_equal 'mocksessionkey'
        end
  
        it "should return a uid" do
          @session.facebook_session.uid.must_equal 'mockuid'
        end
  
        it "should return a secret" do
          @session.facebook_session.secret.must_equal 'mocksecret'
        end
  
        it "should return a sig" do
          @session.facebook_session.sig.must_equal 'cbd80b97f124bf392f76e2ee61168990'
        end
  
        it "should return an access_token" do
          @session.facebook_session.access_token.must_equal 'mockaccesstoken'
        end
      
      end
  
      describe "with previous koala api" do
        
        it "should get user info with the get_user_from_cookie method" do
          @oauth = MiniTest::Mock.new
          
          override Koala::Facebook::OAuth, :new => @oauth
          
          @oauth.expect :respond_to?, false, [:get_user_info_from_cookie]
          @oauth.expect :get_user_from_cookie, @user_info, [@mock_cookies]
        
          @session.facebook_session.session_key.must_equal 'mocksessionkey'
        end
      
      end
        
    end
  
    describe "with no valid facebook cookie" do
  
      it "should return nil" do
        def @session.facebook_app_id; nil end
        
        @session.facebook_session.must_be_nil 
      end
      
    end
    
  end
  
  describe "facebook_session?" do
  
    describe "with a valid facebook session" do
    
      it "should be true" do
        @session.facebook_session?.must_equal true
      end
      
    end
    
    describe "without a valid facebook session" do
  
      it "should be false" do
        override @session, :facebook_app_id => nil
        @session.facebook_session?.must_equal false
      end
      
    end
    
  end
  
  describe "facebook_user" do
    
    describe "with a valid facebook session" do
      
      before do
        @user = {
           "id"         => "mockid",
           "name"       => "Full name",
           "first_name" => "First name",
           "last_name"  => "Last name"
        }
        
        override @session, :facebook_session? => true
         
        @graph_api = MiniTest::Mock.new
        @graph_api.expect :get_object, @user, ['me']
        
        override Koala::Facebook::GraphAPI, :new => @graph_api
      end
  
      it "should initialize the graph api" do
        facebook_session = MiniTest::Mock.new
        access_token     = MiniTest::Mock.new
        facebook_session.expect :access_token, access_token
        
        override @session, :facebook_session => facebook_session
        
        expect Koala::Facebook::GraphAPI, :new, :with => [access_token], :return => @graph_api
        @session.facebook_user
      end
      
      it "should return an OpenStruct" do
        @session.facebook_user.must_be_instance_of OpenStruct
      end
      
      it "should return the user details" do
        @session.facebook_user.name.must_equal 'Full name'
        @session.facebook_user.first_name.must_equal 'First name'
        @session.facebook_user.last_name.must_equal 'Last name'
      end
      
      it "should return the facebook id as uid" do
        @session.facebook_user.uid.must_equal 'mockid'
      end
      
    end
  
    describe "with no valid facebook session" do
      
      it "should return nil" do
        override @session, :facebook_session? => false
        
        @session.facebook_user.must_be_nil
      end
      
    end
    
  end
    
end
