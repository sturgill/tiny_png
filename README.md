## Table Of Contents

- [What Is TinyPNG] (#what-is-tinypng)
- [What Does This Gem Do?] (#what-does-this-gem-do)
- [Installation] (#installation)
- [Usage] (#usage)
	- [Using Blacklists](#using-blacklists)
	- [Using From Rake](#using-from-rake)
	- [Using With Capistrano](#using-with-capistrano)

## What Is TinyPNG

[TinyPNG](http://www.tinypng.org) is a web-based service for shrinking the size of your PNG files.
The process employed preserves full alpha transparency.  In short, it's a free service that makes
PNGs smaller (which reduces bandwidth and increases site performance).

## What Does This Gem Do

TinyPNG has opened up a private beta for programmatically using their services.  Before
this API was introduced, TinyPNG could only be used from their [web interface](http://www.tinypng.org).
And while their homepage is cool and all, manually uploading and saving files is a less-than-enjoyable
process.  The kind of process a computer was made to do for you.  Ergo this gem.

**TinyPNG's API service is currently in private beta.  You will need to request an API key to use this gem.**
[See here](https://twitter.com/tinypng/status/256049113852944384) for details.

This gem interacts with TinyPNG's API to replace a given PNG with its shrunken counterpart.

When you pass a full path into the `shrink` method, it will replace the source image with the image
returned by TinyPNG.  If this process fails for whatever reason, the original image will be restored.
On success, the original image is completely overwritten and is no longer available.

These features can also be used via [Rake](#using-from-rake) or [Capistrano](#using-with-capistrano).
The latter gives you the option of setting up your deploy to automatically convert your images on your
external servers!

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

Note that this will look for the configuration file in `config/tiny_png.yml`.  See the [sample config](https://github.com/sturgill/tiny_png/blob/master/sample_config.yml).
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

### Using Blacklists

There might be times where you want to shrink an entire directory, but exclude certain files.  To do this, you'll need
pass a `TinyPng::Path` object to `@client.shrink`.

```ruby
@paths = TinyPng::Path.new '/images/path'
@paths.blacklist '/images/path/blacklist.png'
@client.shrink @paths
```

The blacklist array takes precedence over anything else inputted into this TinyPng::Path object.

**NOTE:** TinyPng::Path objects are independent of each other.  If you send in multiple path objects to the `shrink` method,
the blacklist from one path object will not impact the other path object.

You can send in TinyPng::Path objects, directories, and full image paths to the shrink method, but each will
be analyzed by itself and the blacklist from any path object will be self-contained.

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

The Rake task uses the [blacklist method](#using-blacklists) in building out the full paths.  This method allows you
to also specify blacklisted paths:

```ruby
SHRINK=/image/directory BLACKLIST=/image/directory/blacklist.png rake tiny_png:shrink
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
SUPPRESS_EXCEPTIONS=true API_KEY=my_api_key SHRINK=/image/directory,/some/image.png BLACKLIST=/image/directory/blacklist.png rake tiny_png:shrink
```

### Using With Capistrano

Since Photoshop doesn't support indexed PNGs with alpha transparency, you might not want to convert the
images on your local box.  With the included Capistrano recipe, you can automatically shrink all files
in your deploy path.

First, include the recipe in your deploy script:

```ruby
require 'tiny_png/recipes'
```

Now you can define the callback wherever makes sense for you.  I would recommend calling this before
the assets are precompiled so that it isn't run multiple times per image:

```ruby
before 'deploy:assets:precompile', 'tiny_png:shrink'
```

Ultimately, the Capistrano recipe will build and run a Rake task on the server, so you need to have the
[Rakefile setup correctly](#using-from-rake).

By default, this script uses the settings found in config/tiny_png.yml.  It also runs through the entire
release directory.  Each option can be overwritten by setting Capistrano variables.  These variables will
be sent directly to a Rake task, so the expected format of these variables is the same as listed above:

```ruby
set :tiny_png_shrink, '/image/directory,/some/image.png'
set :tiny_png_api_key, 'my_api_key'
set :tiny_png_suppress_exceptions, true
set :tiny_png_blacklist, '/image/directory/blacklist.png'
```

Also by default, the task is only run on web servers.  This can be modified by setting the `tiny_png_server_role`
variable:

```ruby
set :tiny_png_server_role, [:web, :app]
```
