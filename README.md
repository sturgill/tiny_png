## Table Of Contents

- [What Is TinyPNG] (#what-is-tinypng)
- [What Does This Gem Do?] (#what-does-this-gem-do)
- [Installation] (#installation)
- [Usage] (#usage)

## What Is TinyPNG

[TinyPNG](http://www.tinypng.org) is a web-based service for shrinking the size of your PNG files.
The process employed preserves full alpha transparency.  In short, it's a free service that makes
PNGs smaller (which reduces bandwidth and increases site performance).

## What Does This Gem Do

TinyPNG has opened up a private beta for programmatically calling using their services.  Before
this API was introduced, TinyPNG could only be used from their [web interface](http://www.tinypng.org).
And while their homepage is cool and all, manually uploading and saving files is a less-than-enjoyable
process.  The kind of process a computer was made to do for you.  Ergo this gem.

This gem interacts with TinyPNG's API to replace a given PNG with its shrunken counterpart.

When you pass a full path into the `shrink` method, it will replace the source image with the image
returned by TinyPNG.  If this process fails for whatever reason, the original image will be restored.
On success, the original image is completely overwritten and is no longer available.

## Installation

If you're using bundler, just add the following to your Gemfile:

```ruby
gem 'tiny_png'
```

## Usage

Create an instance of the `TinyPng::Shrink` class, passing in your API key:

```ruby
@tiny = TinyPng::Shrink.new API_KEY
```

If you want to work with a list of images, and want to silently suppress exceptions, just pass that in the options field:

```ruby
@tiny = TinyPng::Shrink.new API_KEY, { :suppress_exceptions => true }
```

Next, pass in the full path to the image you want to shrink

```ruby
@tiny.shrink '/FULL/PATH/TO/IMAGE.png'
```

The shrunken image will be saved in the same path, effectively overwriting the old file.

**NOTE:**

- There must be a file already at the specified path
- That file must be readable and writeable
- The file name *must* end in `.png`