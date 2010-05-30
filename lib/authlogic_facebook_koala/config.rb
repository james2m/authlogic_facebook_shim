require 'yaml'
require 'ostruct'

module AuthlogicFacebookKoala
  CONFIG = OpenStruct.new( YAML.load_file("#{Rails.root}/config/facebook.yml")[Rails.env] )
end