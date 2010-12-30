require File.expand_path( '../test_helper.rb', File.dirname(__FILE__) )

class SessionTest < ActiveSupport::TestCase
  
  setup :activate_authlogic

  context "Session" do
    
    setup do
      @mock_cookies = MockCookieJar.new
      @mock_cookies['fbs_mockappid'] = {:value => 'access_token=mockaccesstoken&expires=0&secret=mocksecret&session_key=mocksessionkey&sig=cbd80b97f124bf392f76e2ee61168990&uid=mockuid'}
      
      flexmock(controller).should_receive(:cookies).and_return(@mock_cookies).by_default

      @session = flexmock(UserSession.new)
      @session.should_receive(:controller).and_return(controller).by_default
    end

    context "setup - for my own sanity" do
        
      should "set the controller" do
        assert_equal controller, @session.controller
      end
      
      should "set the cookies" do
        assert_equal @mock_cookies, @session.controller.cookies
      end
            
    end
    
    context "config accessors" do

      should "return facebook_app_id" do
        mockappid = 'mockappid'
        flexmock(UserSession).should_receive(:facebook_app_id).and_return(mockappid).once
        assert_equal mockappid, @session.send(:facebook_app_id)
      end

      should "return facebook_api_key" do
        mockapikey = 'mockapikey'
        flexmock(UserSession).should_receive(:facebook_api_key).and_return(mockapikey).once
        assert_equal mockapikey, @session.send(:facebook_api_key)
      end

      should "return facebook_secret_key" do
        mocksecret = 'mocksecret'
        flexmock(UserSession).should_receive(:facebook_secret_key).and_return(mocksecret).once
        assert_equal mocksecret, @session.send(:facebook_secret_key)
      end

      should "return facebook_uid_field" do
        mockuidfield = 'mockuidfield'
        flexmock(UserSession).should_receive(:facebook_uid_field).and_return(mockuidfield).once
        assert_equal mockuidfield, @session.send(:facebook_uid_field)
      end
      
      context "facebook_finder" do

        should "delegate to the class" do
          mockfinder = 'mockfinder'
          flexmock(UserSession).should_receive(:facebook_finder).and_return(mockfinder).once
          assert_equal mockfinder, @session.send(:facebook_finder)
        end

        should "default if the class returns nil" do
          flexmock(UserSession).should_receive(:facebook_finder).and_return(nil).once
          @session.should_receive(:facebook_uid_field).and_return('mockuidfield').once
          assert_equal "find_by_mockuidfield", @session.send(:facebook_finder)
        end

      end

      should "return facebook_auto_register?" do
        flexmock(UserSession).should_receive(:facebook_auto_register).and_return(true).once
        assert @session.send(:facebook_auto_register?)
      end

    end
    
    context "validating with facebook" do
      
      context "with a valid facebook session" do
        
        setup do
          @facebook_session = flexmock('facebook session', :uid => 'mockuid')
          @session.should_receive(:facebook_session).and_return(@facebook_session).by_default
        end

        context "with an existing facebook uid" do
        
          setup do
            @session.should_receive(:facebook_finder).and_return('finder_method').by_default
          
            @user = User.create
            flexmock(User).should_receive('finder_method').with('mockuid').and_return(@user).by_default
          
            @session.save
          end
        
          should "return true for logged_in_with_facebook?" do
            assert @session.logged_in_with_facebook?
          end
        
          should "set attempted_record" do
            assert_equal @user, @session.attempted_record
          end
        
        end

        context "without an existing facebook uid" do
          
          setup do
            @session.should_receive(:facebook_finder).and_return('finder_method').by_default
            flexmock(User).should_receive('finder_method').with('mockuid').and_return(nil).by_default
            
            @user = flexmock(User.new)
            flexmock(User).should_receive(:new).and_return(@user).by_default
          end
        
          context "and facebook_auto_register? true" do
            
            setup do
              @session.should_receive(:facebook_auto_register?).and_return(true).by_default
            end

            should "build a new user on attempted_record" do
              flexmock(User).should_receive(:new).and_return(@user).once
              @session.save
              assert_equal @user, @session.attempted_record
            end
          
            should "attempt to call before_connect on the new user" do
              # TODO this is a bit flakey because I can't get flexmock to mock with(@facebook_session)
              @user.should_receive(:before_connect).with(any).and_return(true).once
              assert @session.save
            end
          
            should "save the new user" do
              @user.should_receive(:save).with(false).and_return(true).at_least.once
              assert @session.save
            end
          
          end
        
          context "and facebook_auto_register? false" do

            should "return false for logged_in_with_facebook?" do
              @session.should_receive(:facebook_auto_register?).and_return(false).once
              @session.save
              
              assert_equal false, @session.logged_in_with_facebook?
            end
          
            should "not set attempted record" do
              @session.should_receive(:facebook_auto_register?).and_return(false).once
              @session.save

              assert_nil @session.attempted_record
            end
          
          end
        
        end

      end

      context "when skip_facebook_authentication is true" do

        should "not attempt to validate with facebook" do
          @session.should_receive(:skip_facebook_authentication).and_return(true).once
          @session.should_receive(:validate_by_facebook).never
          
          assert_equal false, @session.save
        end
        
        should "return false for logged_in_with_facebook?" do
          @session.should_receive(:skip_facebook_authentication).and_return(true).once
          
          assert_equal false, @session.save
          assert_nil @session.logged_in_with_facebook?
        end
        
        should "not set attempted record" do
          @session.should_receive(:skip_facebook_authentication).and_return(true).once

          assert_equal false, @session.save
          assert_nil @session.attempted_record
        end
      end
      
      context "when authenticating_with_unauthorized_record? is false" do

        should "not attempt to validate with facebook" do
          @session.should_receive(:authenticating_with_unauthorized_record?).and_return(false).at_least.once
          @session.should_receive(:validate_by_facebook).never
          
          assert_equal false, @session.save
        end

        should "return false for logged_in_with_facebook?" do
          @session.should_receive(:authenticating_with_unauthorized_record?).and_return(true).at_least.once
          
          assert_equal false, @session.save
          assert_nil @session.logged_in_with_facebook?
        end
        
        should "not set attempted record" do
          @session.should_receive(:authenticating_with_unauthorized_record?).and_return(true).at_least.once

          assert_equal false, @session.save
          assert_nil @session.attempted_record
        end
        
      end
      
      
    end
    
  end
  
end
