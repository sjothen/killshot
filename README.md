# Killshot

Use Killshot to find hotlinks on your domain.

## Usage

Example usage:

```sh
$ ruby killshot.rb --root http://www.example.com --whitelist example.com www.example.com
```

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
