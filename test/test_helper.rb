$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
gem 'activerecord'
require 'active_record'
require "test/unit"
require 'authlogic_facebook_koala'