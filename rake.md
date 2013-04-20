---
layout: page
title: Using Through Rake
---
{% include JB/setup %}

Create a Rakefile in your app's root (or add this to an existing Rakefile):

	require 'your/app'
	require 'tiny_png/tasks'

The `rake tiny_png:shrink` task can be called to shrink images from the command line. To use this rake task, 
you must pass a environment variable called `SHRINK`. `SHRINK` should be a comma-separated list of paths you 
want shrunk. As with the `@client.shrink` method, the `SHRINK` variable accepts both directories and specific image paths.

**NOTE:** Because this works by splitting the environment string into an array based on a comma separator, 
it follows that you can't have commas in your directory or image paths.

The same constraints exist from rake as do from the method call: namely, you must supply the full path, 
and specific image paths must exist, be readable, be writable, and end in .png.

Examples:

Shrink a single file:

	SHRINK=/path/to/image.png rake tiny_png:shrink

Shrink multiple files:

	SHRINK=/path/to/first.png,/path/to/second.png rake tiny_png:shrink

Shrink a whole directory:

	SHRINK=/image/directory rake tiny_png:shrink

Combining directories and specific image files:

	SHRINK=/image/directory,/path/to/image.png rake tiny_png:shrink

The Rake task uses the blacklist method in building out the full paths. This method allows you to also specify blacklisted paths:

	SHRINK=/image/directory BLACKLIST=/image/directory/blacklist.png rake tiny_png:shrink

By default, this rake task will use the settings in config/tiny_png.yml. You can overwrite specific settings by 
passing environment variables. For example, if I do not suppress exceptions in my base config, but want to when 
running a rake task, all I would need to do is set the `SUPPRESS_EXCEPTIONS` environment variable to true:

	SUPPRESS_EXCEPTIONS=true SHRINK=/some/image.png rake tiny_png:shrink

You can pass in an api key in a similar way:

	API_KEY=my_api_key SHRINK=/some/image.png rake tiny_png:shrink

Naturally, these can all be combined in any fashion:

	SUPPRESS_EXCEPTIONS=true API_KEY=my_api_key SHRINK=/image/directory,/some/image.png BLACKLIST=/image/directory/blacklist.png rake tiny_png:shrink

