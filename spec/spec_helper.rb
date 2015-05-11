# use local 'lib' dir in include path
$:.unshift File.dirname(__FILE__)+'/../lib'
require 'audiosearch'
require 'json'
require 'pp'
require 'dotenv'

Dotenv.load

RSpec.configure do |config|
  #config.run_all_when_everything_filtered = true
  #config.filter_run :focus
  config.color = true

end

# assumes ID and SECRET set in env vars
OAUTH_ID     = ENV['AS_ID']
OAUTH_SECRET = ENV['AS_SECRET']
if !OAUTH_ID or !OAUTH_SECRET
  abort("Must set AS_ID and AS_SECRET env vars -- did you create a .env file?")
end

def get_client
  Audiosearch::Client.new(
  :id => OAUTH_ID,
  :secret => OAUTH_SECRET,
  # must duplicate env var because we modify it with gsub
  :host   => (ENV['AS_HOST'] || 'http://localhost:3000').dup.to_s,
  :debug  => ENV['AS_DEBUG'],
  #:croak_on_404 => true
  )
end
