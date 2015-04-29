$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require "urimapper/version"

Gem::Specification.new do |s|
  s.name        = 'urimapper'
  s.version     = UriMapper::VERSION.dup
  s.date        = '2015-04-29'
  s.summary     = "UriMapper"
  s.description = "A utility to parse urls into canonical paths and deterministic hashes"
  s.authors     = ["Craig Waterman"]
  s.email       = 'craigwaterman@gmail.com'
  s.homepage    =
      'http://rubygems.org/gems/urimapper'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_runtime_dependency 'addressable', '~> 2.3'

  s.add_development_dependency 'rspec',   '~> 3.1'
  s.add_development_dependency 'guard-rspec', '~> 4.4'
end
