[![Build Status](https://travis-ci.org/Grouper/flexible-config.png?branch=master)](https://travis-ci.org/Grouper/flexible-config)


FlexibleConfig
==============

FlexibleConfig promotes good OOP design, and the separation of logic and
configuration in your Ruby classes.

FlexibleConfig allows you to set class constants cleanly in ruby with the
heirarchical structure and clean workflow of YML config, without sacrificing
the flexibility and immediacy of ENVironment variables.

### Here is how your class constants could look like using FlexibleConfig:

```ruby
module Bidding
  class Calculator
    FlexibleConfig.use 'auction.bidding' do |config|
      BASE_RATE   = config['base_rate']
      TIME_DECAY  = config['time_decay']
      WIGGLE_ROOM = config['wiggle_room']
    end
  end
end
```

Or the more safer, (but more verbose) syntax:

```ruby
module Bidding
  class Calculator
    FlexibleConfig.use 'auction.bidding' do |cfg|
      BIDDING_ENABLED = cfg.fetch('enabled') { true }
      BIDDER_EMAIL    = cfg.to_s('email_from')
      BASE_RATE       = cfg.to_f('base_rate') { 1.0 }
      TIME_DECAY      = cfg.to_f('time_decay') { 3.0 }
      ATTEMPTS        = cfg.to_i('wiggle_room') { 2 }
    end
  end
end
```

### Then config as follows:

#### In YAML:

`config/settings/auction.yml`

```yml
default:
  base_rate: 1.0
  time_decay: 3.0
  wiggle_room: 0.2

development:
  wiggle_room: 0.6

production:
  wiggle_room: 0.2
```

#### Using ENV variables to override:

```
AUCTION_BIDDING_BASE_RATE=1.0
AUCTION_BIDDING_TIME_DECAY=3.0
AUCTION_BIDDING_WIGGLE_ROOM=0.2
```

#### Casting Booleans from ENV

If your ENV variable is equal to the string 'true' or 'false' then
using the default `#fetch` method on the config object will cast it to the
Ruby `TrueClass` or `FalseClass` automatically.

#### Casting of Other Types

Casting to any Ruby type will work as long as the Ruby object and its string
representation are safely interchangable:

```
example.yml

default:
  safe: '123'
  unsafe: '123oops'
```

```ruby
FlexibleConfig.use 'example' do |cfg|
  BASE_RATE  = cfg.to_i('safe') # => 123
  TIME_DECAY = cfg.to_i('unsafe') # => raises UnsafeConversion
end
```

- - - - -

## Contributing

If you'd like to become a contributor, the easiest way it to fork this repo, make your changes, run the specs and submit a pull request once they pass.

To run specs, run `bundle install && bundle exec rspec`

If your changes seem reasonable and the specs pass I'll give you commit rights to this repo and add you to the list of people who can push the gem.


## Copyright

Copyright (c) 2015 Grouper. See LICENSE for details.
