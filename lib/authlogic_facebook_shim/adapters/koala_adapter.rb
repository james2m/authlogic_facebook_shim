module AuthlogicFacebookShim
    module Adapters
      module KoalaAdapter
    
        def facebook_session
          @facebook_session ||= begin
            if controller.cookies.has_key?("fbs_#{facebook_app_id}")
              oauth = Koala::Facebook::OAuth.new(facebook_app_id, facebook_secret_key)
              if oauth.respond_to?(:get_user_info_from_cookie)
                user_info = oauth.get_user_info_from_cookie(controller.cookies)
              else
                user_info = oauth.get_user_from_cookie(controller.cookies)
              end
              OpenStruct.new( user_info )
            end
          end
        end

        def facebook_session?
          !facebook_session.nil?
        end
   
        def facebook_user
          @facebook_user ||= begin
            facebook_graph = Koala::Facebook::GraphAPI.new(facebook_session.access_token)
            user = facebook_graph.get_object('me')
            user[:uid] = user.delete('id')
            OpenStruct.new( user )
          end if facebook_session?
        end
        
      end
    end
end
    