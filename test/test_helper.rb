require "test/unit"
require "rubygems"
require "ruby-debug"
require "active_record"

ActiveRecord::Schema.verbose = false
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")
ActiveRecord::Base.configurations = true
ActiveRecord::Schema.define(:version => 1) do
  create_table :users do |t|
    t.datetime  :created_at
    t.datetime  :updated_at
    t.integer   :lock_version, :default => 0
    t.string    :login
    t.string    :crypted_password
    t.string    :password_salt
    t.string    :persistence_token
    t.string    :single_access_token
    t.string    :perishable_token
    t.string    :openid_identifier
    t.string    :email
    t.string    :first_name
    t.string    :last_name
    t.integer   :login_count, :default => 0, :null => false
    t.integer   :failed_login_count, :default => 0, :null => false
    t.datetime  :last_request_at
    t.datetime  :current_login_at
    t.datetime  :last_login_at
    t.string    :current_login_ip
    t.string    :last_login_ip
    t.string    :facebook_uid
    t.string    :facebook_session_key
    t.string    :facebook_access_token
    t.string    :facebook_expires
    t.string    :facebook_secret
    t.string    :facebook_sig
    
  end
end

require "active_record/fixtures"
Rails = true # to trick authlogic into loading the rails adapter
require File.dirname(__FILE__) + "/../../authlogic/lib/authlogic"
require File.dirname(__FILE__) + "/../../authlogic/lib/authlogic/test_case"
require File.dirname(__FILE__) + '/../lib/authlogic_facebook_koala'  unless defined?(AuthlogicFacebookKoala)
require File.dirname(__FILE__) + '/libs/user'
require File.dirname(__FILE__) + '/libs/user_session'

class ActiveSupport::TestCase
  include ActiveRecord::TestFixtures
  self.fixture_path = File.dirname(__FILE__) + "/fixtures"
  self.use_transactional_fixtures = false
  self.use_instantiated_fixtures  = false
  self.pre_loaded_fixtures = false
  fixtures :all
  setup :activate_authlogic
  
  private
    def activate_authlogic
      Authlogic::Session::Base.controller = controller
    end
    
    def controller
      @controller ||= Authlogic::ControllerAdapters::RailsAdapter.new(ActionController.new)
    end
end

# --- Sample valid cookie hash generated with the code below
# cookie_hash = {'fbs_233423200151' => 'access_token=233423200151|6892d62675cd952ade8b3f9b-6184456410|xrNaOlTCUF0QFZrJCHmVWzTb5Mk.&expires=0&secret=339a00cdafe6959c3caa1b8004e5f8db&session_key=6892d62675cd952ade8b3f9b-6184456410&sig=19d3c9ccb5b5a55d680ed1cf18698f57&uid=6184456410'}

# --- Generates user params from cookie for this app_id & secret
# oauth = Koala::Facebook::OAuth.new('233423200151', '8371c9fc95a7d0a3d9cdb6bbacfea306')
# params = oauth.get_user_from_cookie(cookie_hash)

# --- Generates a signature for a cookie hash
# fb_cookie = cookie_hash["fbs_233423200151"]
# components = {}
# fb_cookie.split("&").map {|param| param = param.split("="); components[param[0]] = param[1]}
# auth_string = components.keys.sort.collect {|a| a == "sig" ? nil : "#{a}=#{components[a]}"}.reject {|a| a.nil?}.join("")
# sig = Digest::MD5.hexdigest(auth_string + '8371c9fc95a7d0a3d9cdb6bbacfea306')

