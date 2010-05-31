require 'ostruct'
module AuthlogicFacebookKoala
  module Controller
    
    def self.included(controller)
      controller.send(:helper_method, :facebook_user?, :facebook_user, :facebook_session?, :facebook_session)
    end
  
    # TODO update to use the new facebook_user stuff we are going to create
    # can probably kill this now.
    def set_current_account_session_from_facebook_session
      unless current_account_session
        @current_account_session = AccountSession.new
        @current_account_session.account = Account.find_by_facebook_uid(facebook_session.user.uid)
      end
    end
  
    def facebook_user?
      !!facebook_user
    end
  
    def facebook_user
      if @facebook_user
        return @facebook_user 
      elsif facebook_session?
        facebook_graph = Koala::Facebook::GraphAPI.new(facebook_session.access_token)
        user = facebook_graph.get_object('me')
        user[:uid] = user.delete('id')
        return @facebook_user = OpenStruct.new( user )
      end
    end
  
    def facebook_session?
      !!facebook_session
    end
    
    protected
    
    def facebook_session
      @facebook_session
    end
    
    def set_facebook_session
      if @facebook_session
        return(@facebook_session) 
      elsif cookies.has_key?("fbs_#{facebook_params.app_id}")
        oauth = Koala::Facebook::OAuth.new(facebook_params.app_id, facebook_params.secret_key)
        @facebook_session = OpenStruct.new( oauth.get_user_from_cookie(cookies) )
      end
    end
      
    private
    
    def facebook_params
      AuthlogicFacebookKoala::CONFIG
    end
    
  end
end