# Puddle

Simple object pooling.

```ruby
class Particle
  include Puddle
end

# drink from the pool
p = Particle.drink

# spit the object back in
p.spit!

## Installation

Add this line to your application's Gemfile:

    gem 'puddle'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install puddle

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
