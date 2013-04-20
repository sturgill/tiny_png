---
layout: page
title: Usage
tagline: the tiny_png gem
---
{% include JB/setup %}

Create an instance of the `TinyPng::Client` class:

	@client = TinyPng::Client.new

Note that this will look for the configuration file in `config/tiny_png.yml`. See the 
[sample config](https://github.com/sturgill/tiny_png/blob/master/sample_config.yml). If you choose to 
not use the config file, you will need to pass in your API key in the optional hash:

	@client = TinyPng::Client.new :api_key => 'my_api_key'

If you want to work with a list of images, and want to silently suppress exceptions, change that 
in the config file or pass it into the optional hash:

	@client = TinyPng::Client.new :suppress_exceptions => true

Next, pass in the full paths to the images you want to shrink (you can also pass in whole directories)

	@client.shrink '/FULL/PATH/TO/IMAGE.png'
	@client.shrink '/FULL/PATH/TO/image.png', '/FULL/PATH/TO/ANOTHER/image.png', '/DIRECTORY/WITH/LOTS/OF/IMAGES'

The `shrink` method will return a hash of arrays letting you know which paths were successfully 
overwritten and which ones failed:

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

Each successfully shrunken image will overwrite the original file.

**NOTE:**

For each image path analyzed (whether sent in directly or picked out of a folder):

- There must be a file already at the specified path
- That file must be readable and writeable
- The file name must end in .png

### Using Blacklists

There might be times where you want to shrink an entire directory, but exclude certain files. To do this, 
you'll need pass a `TinyPng::Path` object to `@client.shrink`.

	@paths = TinyPng::Path.new '/images/path'
	@paths.blacklist '/images/path/blacklist.png'
	@client.shrink @paths

The blacklist array takes precedence over anything else inputted into this `TinyPng::Path` object.

NOTE: `TinyPng::Path` objects are independent of each other. If you send in multiple path objects to 
the `shrink` method, the blacklist from one path object will not impact the other path object.

You can send in `TinyPng::Path` objects, directories, and full image paths to the `shrink` method, but each 
will be analyzed by itself and the blacklist from any path object will be self-contained.