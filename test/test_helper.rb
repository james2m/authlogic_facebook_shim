# Load the latest minitest
require 'rubygems'
gem     'minitest'

# Load the environment
ENV['RAILS_ENV'] = 'test'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

# Load the testing framework
require 'minitest/autorun'
require 'rails/test_help'
require 'authlogic/test_case'
require 'override'

if defined?(MiniTest::Unit::TestCase)
  MiniTest::Unit::TestCase.class_eval do 
    # Mix Authlogic::TestCase into MiniTest to make activate_authlogic and controller available
    include Authlogic::TestCase
    # Mix Override in because it's just stubbing and expectations that feel like MiniTest
    include Override
  end
end

Rails.backtrace_cleaner.remove_silencers!

# Run the migrations
ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.migrate("#{Rails.root}/db/migrate")

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

