# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "webhallon_wrapper"
  s.version     = "2.0.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Linus Oleander"]
  s.email       = ["linu@oleander.nu"]
  s.homepage    = "http://github.com/oleander/webhallon_wrapper"
  s.summary     = %q{Webhallon client}
  s.description = %q{Webhallon client}

  s.rubyforge_project = "webhallon_wrapper"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency("rest-client")

  s.required_ruby_version = "~> 1.9.0"
end
