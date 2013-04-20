---
layout: page
title: Deploying With Capistrano
---
{% include JB/setup %}

Since Photoshop doesn't support indexed PNGs with alpha transparency, you might not want to convert 
the images on your local box. With the included Capistrano recipe, you can automatically shrink all 
files in your deploy path.

First, include the recipe in your deploy script:

	require 'tiny_png/recipes'

Now you can define the callback wherever makes sense for you. I would recommend calling this before 
the assets are precompiled so that it isn't run multiple times per image:

	before 'deploy:assets:precompile', 'tiny_png:shrink'

Ultimately, the Capistrano recipe will build and run a Rake task on the server, so you need to have 
the [Rakefile setup correctly](rake.html).

By default, this script uses the settings found in config/tiny_png.yml. It also runs through the entire 
release directory. Each option can be overwritten by setting Capistrano variables. These variables will 
be sent directly to a Rake task, so the expected format of these variables is the same as listed above:

	set :tiny_png_shrink, '/image/directory,/some/image.png'
	set :tiny_png_api_key, 'my_api_key'
	set :tiny_png_suppress_exceptions, true
	set :tiny_png_blacklist, '/image/directory/blacklist.png'

Also by default, the task is only run on web servers. This can be modified by setting the `tiny_png_server_role` variable:

	set :tiny_png_server_role, [:web, :app]