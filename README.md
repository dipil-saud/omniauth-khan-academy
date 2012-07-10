# OmniAuth Khan Academy

This is an [OmniAuth 1.0](https://github.com/intridea/omniauth) strategy for authenticating to Khan Academy.

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-khan-academy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-khan-academy

## Usage

Register[http://www.khanacademy.org/api-apps/register] your app at Khan Academy and get your consumer token and secret.


In a Rack application:

```ruby
use OmniAuth::Builder do
  provider :khan_academy, CONSUMER_TOKEN, CONSUMER_SECRET
end
```

For Rails, put this in your omniauth configuration file:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :khan_academy, CONSUMER_TOKEN, CONSUMER_SECRET
end
```

Restart the server and visit "*/auth/khan_academy" to try it out.

The default callback is routed to "*/auth/khan_academy/callback" but you can override it as shown:

    provider :khan_academy, CONSUMER_TOKEN, CONSUMER_SECRET, callback_url: "my_callback_url"

## Author

[Dipil Saud (@dipil-saud)](https://github.com/dipil-saud)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
