Audiosear.ch Ruby Client
=========================================

Ruby client SDK for https://www.audiosear.ch/

See docs at https://www.audiosear.ch/developer/

OAuth credentials are available from https://www.audiosear.ch/oauth/applications

Example:

```ruby
require 'audiosearch'

# create a client
client = Audiosearch::Client.new(
  :id     => 'oauth_id',
  :secret => 'oauth_secret',
  :host   => 'https://www.audiosear.ch/'
  :debug  => false
)

# fetch a show with id 1234
resp = client.get('/shows/1234')

# fetch a specific episode
episode = client.get_episode(5678)

```

## Development

To run the Rspec tests, create a **.env** file in the checkout
with the following environment variables set to meaningful values:

```
AS_ID=somestring
AS_SECRET=sekritstring
AS_HOST=http://audiosear.ch.dev
```
