# fuse-common

Gem contains integrations, common code without business logic, etc. which used by Fuse monolith and it's microservices

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fuse-common'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fuse-common

## Usage

Require needed libraries to use them.


### Airbrake integration

#### For *Rails* (without customization)

Add require line to run initializer to the bottom of `application.rb`:
```ruby
require 'fuse_common/engine'
```
#### Standalone

```ruby
require 'fuse_common/airbrake_config'
FuseCommon::AirbrakeConfig.new(Figaro.env).apply
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Fuseit/fuse-common.
