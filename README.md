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

**TinyPNG's API service is currently in private beta.  You will need to request an API key to use this gem.**
[See here](https://twitter.com/tinypng/status/256049113852944384) for details.

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

Create an instance of the `TinyPng::Client` class, passing in your API key:

```ruby
@client = TinyPng::Client.new API_KEY
```

If you want to work with a list of images, and want to silently suppress exceptions, just pass that in the options field:

```ruby
@client = TinyPng::Client.new API_KEY, { :suppress_exceptions => true }
```

Next, pass in the full paths to the images you want to shrink (you can also pass in whole directories)

```ruby
@client.shrink '/FULL/PATH/TO/IMAGE.png'
```

```ruby
@client.shrink '/FULL/PATH/TO/image.png', '/FULL/PATH/TO/ANOTHER/image.png', '/DIRECTORY/WITH/LOTS/OF/IMAGES'
```

The `shrink` method will return a hash of arrays letting you know which paths were successfully overwritten and which
ones failed:

```
{
	:success => [
		'/THIS/ONE/WAS/overwritten.png',
		'/THIS/ONE/WAS/ALSO/overwritten.png'
	], 
	:failure => [
		'/THIS/FAILED/AND/WAS/reverted.png',
		'/THIS/ISNT/A/png.gif'
	]
}
```

Each successfully shrunken image will overwrite the original file.

**NOTE:**

For each image path analyzed (whether sent in directly or picked out of a folder):

- There must be a file already at the specified path
- That file must be readable and writeable
- The file name *must* end in `.png`