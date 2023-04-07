# Shrine::Thumbhash

Shrine plugin for generate [Thumbhash](https://evanw.github.io/thumbhash/) from image attachments.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add shrine-thumbhash

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install shrine-thumbhash

## Requirements
- [ruby-vips gem](https://rubygems.org/gems/ruby-vips) (default or when you specify `:ruby_vips` to image_loader option)
- [mini_magick gem](https://rubygems.org/gems/mini_magick) (When you specify `:mini_magick` to image_loader option)

## Usage

```ruby
require "shrine"
require "shrine/storage/memory"
require "shrine/plugins/thumbhash"

Shrine.plugin :thumbhash
Shrine.storages[:store] = Shrine::Storage::Memory.new
uploader = Shrine.new(:store)

image = File.open("path/to/image.jpg", binmode: true)
uploaded_file = uploader.upload(image)

uploaded_file.thumbhash
# => Base64 encoded thumbhash such as "YJqGPQw7sFlslqhFafSE+Q6oJ1h2iHB2Rw=="
uploaded_file.thumbhash_urlsafe
# => URLsafe Base64 encoded thumbhash such as "YJqGPQw7sFlslqhFafSE-Q6oJ1h2iHB2Rw=="
```

## Options

### padding
When specify false, thumbhash will be without padding.

Default: `true`
```ruby
Shrine.plugin :thumbhash, padding: false
 ... # omit
uploaded_file.thumbhash
# => Base64 encoded thumbhash without padding such as "YJqGPQw7sFlslqhFafSE+Q6oJ1h2iHB2Rw"
uploaded_file.thumbhash_urlsafe
# => URLsafe Base64 encoded thumbhash without padding such as "YJqGPQw7sFlslqhFafSE-Q6oJ1h2iHB2Rw"
```

### image_loader
A ruby object be used for loading and resizeing image.  
When you choose from our implementations, you can specify them by Symbol.

- `:ruby_vips`
- `:mini_magick`

Default: `:ruby_vips`
```ruby
Shrine.plugin :thumbhash, image_loader: :mini_magick
```

If you want to use something other than our implementations, you can implement it yourself.  
See `lib/shrine/plugins/thumbhash/image_loader/ruby_vips.rb`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/takayamaki/shrine-thumbhash.
