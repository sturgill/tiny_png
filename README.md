## Table Of Contents

- [What Is TinyPNG] (#what-is-tinypng)
- [What Does This Gem Do?] (#what-does-this-gem-do)
- [Installation] (#installation)
- [Usage] (#usage)
	- [Using From Rake](#using-from-rake)

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

Create an instance of the `TinyPng::Client` class:

```ruby
@client = TinyPng::Client.new
```

Note that this will look for the configuration file in `config/tiny_png.yml`.  See the [sample config](https://github.com/sturgill/tiny_png/sample_config.yml).
If you choose to not use the config file, you will need to pass in your API key in the optional hash:

```ruby
@client = TinyPng::Client.new :api_key => 'my_api_key'
```

If you want to work with a list of images, and want to silently suppress exceptions, change that in the config file or
pass it into the optional hash:

```ruby
@client = TinyPng::Client.new :suppress_exceptions => true
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

### Using From Rake

Create a Rakefile in your app's root (or add this to an existing Rakefile):

```ruby
require 'your/app'
require 'tiny_png/tasks'
```

The `rake tiny_png:shrink` task can be called to shrink images from the command line.  To use this rake task,
you must pass a environment variable called `SHRINK`.  `SHRINK` should be a comma-separated list of paths you want shrunk.
As with the `@client.shrink` method, the SHRINK variable accepts both directory and specific image paths.

**NOTE:** Because this works by splitting the environment string into an array based on a comma separator, it follows
that you can't have commas in your directory or image paths.

The same constraints exist from rake as do from the method call: namely, you must supply the full path, and specific
image paths must exist, be readable, be writable, and end in `.png`.

**Examples:**

Shrink a single file:

```ruby
SHRINK=/path/to/image.png rake tiny_png:shrink
```

Shrink multiple files:

```ruby
SHRINK=/path/to/first.png,/path/to/second.png rake tiny_png:shrink
```

Shrink a whole directory:

```ruby
SHRINK=/image/directory rake tiny_png:shrink
```

Combining directories and specific image files:

```ruby
SHRINK=/image/directory,/path/to/image.png rake tiny_png:shrink
```

By default, this rake task will use the settings in config/tiny_png.yml.  You can overwrite specific settings by passing
environment variables.  For example, if I do not suppress exceptions in my base config, but want
to when running a rake task, all I would need to do is set the `SUPPRESS_EXCEPTIONS` environment variable to true:

```ruby
SUPPRESS_EXCEPTIONS=true SHRINK=/some/image.png rake tiny_png:shrink
```

You can pass in an api key in a similar way:

```ruby
API_KEY=my_api_key SHRINK=/some/image.png rake tiny_png:shrink
```

Naturally, these can all be combined in any fashion:

```ruby
SUPPRESS_EXCEPTIONS=true API_KEY=my_api_key SHRINK=/image/directory,/some/image.png rake tiny_png:shrink
```