# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "webhallon_wrapper/version"

Gem::Specification.new do |s|
  s.name        = "webhallon_wrapper"
  s.version     = WebhallonWrapper::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["TODO: Write your name"]
  s.email       = ["TODO: Write your email address"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "webhallon_wrapper"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency("json_pure")
  s.add_dependency("rest-client")
   
  s.add_development_dependency("rspec")
  s.add_development_dependency("webmock")
end
