Gem::Specification.new do |s|
  s.name        = 'audiosearch'
  s.version     = '1.0.1'
  s.date        = '2015-07-01'
  s.rubyforge_project = "nowarning"
  s.summary     = "Ruby client for the Audiosear.ch API"
  s.description = "Ruby client for the Audiosear.ch API. See https://www.audiosear.ch/"
  s.authors     = ["Peter Karman"]
  s.email       = 'peter@popuparchive.com'
  s.homepage    = 'https://github.com/popuparchive/audiosearch-client-ruby'
  s.files       = ["lib/audiosearch.rb"]
  s.license     = 'Apache'
  s.add_runtime_dependency "faraday"
  s.add_runtime_dependency "faraday_middleware"
  s.add_runtime_dependency "excon"
  s.add_runtime_dependency "hashie"
  s.add_runtime_dependency "oauth2"
  s.add_development_dependency "rspec"
  s.add_development_dependency "dotenv"

end
