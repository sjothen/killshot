# Killshot

Use Killshot to find hotlinks on your domain.

## Installation

Add this line to your application's Gemfile:

    gem 'killshot'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install killshot

## Usage

Example usage:

```sh
$ killshot -r http://www.example.com -w example.com www.example.com
```

Note: Root host will be used as the default whitelist if none is specified.

### Options

```
        --root, -r <s>:   URL where we start crawling
  --whitelist, -w <s+>:   List of allowed domains
         --version, -v:   Print version and exit
            --help, -h:   Show this message
```

## License

Copyright (c) Stephen Michael Jothen

Licensed under the MIT License

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
