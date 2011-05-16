# URIParser

## What?

This is a very simple native gem to Google's
[chromium URL canonicalization library](http://code.google.com/p/google-url/).
Google's code is is BSD-licensed.

This gem requires the ICU library. Under Linux (Ubuntu) the proper
version may be installed via apt-get (e.g. `apt-get install libicu40`).
Under Mac OSX it may be installed with homebrew (e.g. `brew install icu4c`).  Note that after installing with homebrew, you will likely have to `brew link icu4c`. See the printout after installing the package for details. If you still have difficulty compiling this plugin after linking icu4c in homebrew your homebrew includes might not be listed in your include path for gcc. Try running `export CPATH="/usr/local/include"` and then installing the gem.

## Why?

[Addressable](http://addressable.rubyforge.org/) provides the same
functionality (and more!) but is slow.  This gem is much faster.

## Example

    require 'uri_parser'

    noncan = 'http://руцентр.рф/Iñtërnâtiônàlizætiøn!?i18n=true'
    url = URIParser.new(noncan)
    puts <<TO_THE_END
        non-canonicalized: #{noncan}
        canonicalized: #{url.uri}
        scheme: #{url.scheme}
        host: #{url.host}
        port: #{url.port}
        path: #{url.path}
        query: #{url.query}
        valid: #{url.valid?}
    TO_THE_END

__Note__: If a URL is marked as invalid then the state/value of any of its other properties is undefined.

## Copyright

Copyright 2011 SEOmoz.  See LICENSE for details.

google-url is copyright Google.

