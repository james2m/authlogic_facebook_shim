require File.expand_path( '../../test_helper.rb', File.dirname(__FILE__) )

class AuthlogicFacebookShim::Adapters::KoalaAdapterTest < ActiveSupport::TestCase
  
  setup :activate_authlogic

  context "Adapters::KoalaAdapter" do
    setup do
      @user_info = {
        'session_key' => 'mocksessionkey',
        'expires' => '0',
        'uid' => 'mockuid',
        'sig' => 'cbd80b97f124bf392f76e2ee61168990',
        'secret' => 'mocksecret',
        'access_token' => 'mockaccesstoken'
      }
      @mock_cookies = MockCookieJar.new
      @mock_cookies['fbs_mockappid'] = {:value => 'access_token=mockaccesstoken&expires=0&secret=mocksecret&session_key=mocksessionkey&sig=cbd80b97f124bf392f76e2ee61168990&uid=mockuid'}
      @session = flexmock(UserSession.new)
      @controller = flexmock('Controller')
      
      @session.should_receive(:facebook_app_id).and_return('mockappid').by_default
      @session.should_receive(:facebook_api_key).and_return('mockapikey').by_default
      @session.should_receive(:facebook_secret_key).and_return('mocksecret').by_default
      @session.should_receive(:controller).and_return(@controller).by_default
      @controller.should_receive(:cookies).and_return(@mock_cookies).by_default
    end

    context "setup - for my own sanity" do
        
      should "set the controller" do
        assert_equal @controller, @session.controller
      end
      
      should "set the cookies" do
        assert_equal @mock_cookies, @session.controller.cookies
      end
      
      should "set the facebook_app_id" do
        assert_equal 'mockappid', @session.facebook_app_id
      end
      
      should "set the facebook_secret_key" do
        assert_equal 'mocksecret', @session.facebook_secret_key
      end
      
      should "set the facebook_api_key" do
        assert_equal 'mockapikey', @session.facebook_api_key
      end
      
    end

    context "facebook_session" do

      context "with a valid facebook cookie" do
        
        context "and koala support for get_user_info_from_cookie" do

          should "return a session_key" do
            assert_equal 'mocksessionkey', @session.facebook_session.session_key
          end

          should "return a uid" do
            assert_equal 'mockuid', @session.facebook_session.uid
          end

          should "return a secret" do
            assert_equal 'mocksecret', @session.facebook_session.secret
          end

          should "return a sig" do
            assert_equal 'cbd80b97f124bf392f76e2ee61168990', @session.facebook_session.sig
          end

          should "return an access_token" do
            assert_equal 'mockaccesstoken', @session.facebook_session.access_token
          end
        
        end

        context "with previous koala api" do
          
          should "get user info with the get_user_from_cookie method" do
            @oauth = flexmock('oauth')
            flexmock(Koala::Facebook::OAuth).should_receive(:new).and_return(@oauth).once
            @oauth.should_receive(:respond_to?).with(:get_user_info_from_cookie).and_return(false).once
            @oauth.should_receive(:get_user_from_cookie).with(@mock_cookies).and_return(@user_info).once

            assert_equal 'mocksessionkey', @session.facebook_session.session_key
          end
        
        end

      end

      context "with no valid facebook cookie" do

        should "return nil" do
          @session.should_receive('facebook_app_id').and_return(nil).once
          assert_nil @session.facebook_session
        end
        
      end
      
    end
    
    context "facebook_session?" do

      context "with a valid facebook session" do
      
        should "be true" do
          assert @session.facebook_session?
        end
        
      end
      
      context "without a valid facebook session" do

        should "return nil" do
          @session.should_receive('facebook_app_id').and_return(nil).once
          assert_equal false, @session.facebook_session?
        end
        
      end
      
    end

    context "facebook_user" do
      
      context "with a valid facebook session" do
        
        setup do
          @user = {
             "id"         => "mockid",
             "name"       => "Full name",
             "first_name" => "First name",
             "last_name"  => "Last name"
          }
          
          @access_token = flexmock('access token')
          @session.should_receive('facebook_session.access_token').and_return(@access_token).by_default
          @session.should_receive('facebook_session?').and_return(true).by_default
           
          @graph_api = flexmock('graph api', :get_object => @user)
          flexmock(Koala::Facebook::GraphAPI).should_receive(:new).and_return(@graph_api).by_default
        end

        should "initialize the graph api" do
          flexmock(Koala::Facebook::GraphAPI).should_receive(:new).with(@access_token).and_return(@graph_api).once
          @session.facebook_user
        end
        
        should "return an OpenStruct" do
          assert @session.facebook_user.is_a?(OpenStruct)
        end
        
        should "return the user details" do
          assert_equal 'Full name', @session.facebook_user.name
          assert_equal 'First name', @session.facebook_user.first_name
          assert_equal 'Last name', @session.facebook_user.last_name
        end
        
        should "return the facebook id as uid" do
          assert_equal 'mockid', @session.facebook_user.uid
        end
        
      end

      context "with no valid facebook session" do

        should "return nil" do
          @session.should_receive('facebook_session?').and_return(false).once
          assert_nil @session.facebook_user
        end
        
      end
      
    end
    
  end
  
end
