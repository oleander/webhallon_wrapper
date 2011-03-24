# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "webhallon_wrapper"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Linus Oleander"]
  s.email       = ["linu@oleander.nu"]
  s.homepage    = "github.com/oleander/webhallon_wrapper"
  s.summary     = %q{Makes it possible to interact against libspotify through the web}
  s.description = %q{Makes it possible to interact against libspotify through the web using Ruby}

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
