Gem::Specification.new do |s|
  s.name = %q{authlogic_facebook_koala}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">=1.2.0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James McCarthy"]
  s.date = %q{2010-05-27}
  s.description = %q{Authlogic plugin to support Facebook Javascript OAuth2 Sessions, using the koala gem for facebook graph access.}
  s.email = %q{james2mccarthy@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = Dir.glob('**/*') - Dir.glob('authlogic_facebook_koala*.gem')
  s.homepage = %q{http://github.com/james2m/authlogic_facebook_koala}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Authlogic plugin to support Facebook OAuth2 javascript sessions using koala gem}
  s.test_files = Dir.glob('test/**/*')

  s.add_runtime_dependency('authlogic', ">= 2.1.3")
  s.add_runtime_dependency('koala', ">= 0.7.1")
  s.add_development_dependency('rails', '=2.3.5')
  s.add_development_dependency('flexmock')
  s.add_development_dependency('jeweler')
  s.add_development_dependency('shoulda')
  s.add_development_dependency('sqlite3-ruby')
  s.add_development_dependency('test-unit')
end

