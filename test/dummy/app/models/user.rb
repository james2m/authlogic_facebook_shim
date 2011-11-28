class User < ActiveRecord::Base
  acts_as_authentic
  
  def before_connect(facebook_session)
    true
  end
  
end