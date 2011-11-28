# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "authlogic_facebook_shim/version"

Gem::Specification.new do |s|
  s.name    = %q{authlogic_facebook_shim}
  s.version = AuthlogicFacebookShim::VERSION

  s.authors          = ["James McCarthy"]
  s.date             = %q{2011-11-26}
  s.description      = %q{Authlogic extension to support Facebook OAuth2 javascript sessions. Currently requires koala but is easily extended for other facebook api wrappers.}
  s.email            = %q{james2mccarthy@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files         = Dir.glob('**/*') - Dir.glob('authlogic_facebook_shim*.gem')
  s.homepage      = %q{http://github.com/james2m/authlogic_facebook_shim}
  s.rdoc_options  = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.summary       = %q{Authlogic extension to support Facebook Javascript OAuth2 Sessions.}
  s.test_files    = Dir.glob('test/**/*')

  s.add_runtime_dependency 'authlogic', '~>3.0'
  
  s.add_development_dependency 'rails',     '~>3.0'
  s.add_development_dependency "minitest",  '~>2'
  s.add_development_dependency "override"
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'koala'
end

