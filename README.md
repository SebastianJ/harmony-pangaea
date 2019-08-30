# Harmony::Pangaea

This is a collection of tools to interact with Harmony's Pangea testnet.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'harmony-pangaea'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install harmony-pangaea

## Usage

### Parse network status

This allows you to parse the network status from https://harmony.one/pga/network in order to insert it in a database, send transactions etc. etc.

```ruby
Harmony::Pangaea::Network.new.status

=> {:shards=>
  {0=>
    {:shard_number=>0,
     :block_number=>62972,
     :status=>:online,
     :last_updated=>#<DateTime: 2019-08-30T09:36:11+00:00 ((2458726j,34571s,0n),+0s,2299161j)>,
     :nodes=>
      {:online=>
        ["one10vk9pjvrjgne5wyw8l50rmrh4tpjwgfpqmuz6q",
         "one12cxl7l5hfx4wxtlp4zfttaap3apdmyvj260kr8",
         "one12d53ksxpvdcsdflzyg9sjdpcp0hzu9eqm7qf4n",
         "one12emxdmtwetakanpv345eednsfkzmtu9zttfvhy",
         "one12hkj564gwcvfruqaw4sxnlrcf9hfr87kydjpfg",
         ...
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SebastianJ/harmony-pangaea. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Harmony::Pangaea project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/SebastianJ/harmony-pangaea/blob/master/CODE_OF_CONDUCT.md).
