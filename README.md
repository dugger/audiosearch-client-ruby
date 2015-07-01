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
  :host   => 'https://www.audiosear.ch/',
  :debug  => false,
)

# fetch a show with id 1234
show = client.get('/shows/1234')
# or more idiomatically
show = client.get_show(1234)

# fetch an episode
episode = client.get('/episodes/5678')
# or idiomatically
episode = client.get_episode(5678)

# search
res = client.search({ q: 'test' })
res.results.each do |episode|
  printf("[%s] %s (%s)\n", episode.id, episode.title, episode.show_title)
end

```

## Development

To run the Rspec tests, create a **.env** file in the checkout
with the following environment variables set to meaningful values:

```
AS_ID=somestring
AS_SECRET=sekritstring
AS_HOST=http://audiosear.ch.dev
```
