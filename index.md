---
layout: page
title: Overview
tagline: the tiny_png gem
---
{% include JB/setup %}

### What is TinyPNG

[TinyPNG](http://www.tinypng.org) is a web-based service for shrinking the size of your PNG files.
The process employed preserves full alpha transparency. In short, it's a free service that makes
PNGs smaller thereby reducing bandwidth and increasing site performance.

### What does this gem do

TinyPNG has opened up a private beta for programmatically using their services. Before this API was 
introduced, TinyPNG could only be used from their [web interface](http://www.tinypng.org). And while 
their homepage is cool and all, manually uploading and saving files is a less-than-enjoyable process.
The kind of process a computer was made to do for you. Ergo this gem.

**TinyPNG's API service is currently in private beta. You will need to request an API key to use this gem.**
[See here](https://twitter.com/tinypng/status/256049113852944384) for details.

This gem interacts with TinyPNG's API to replace a given PNG with its shrunken counterpart.

When you pass a full path into the `shrink` method, it will replace the source image with the image 
returned by TinyPNG. If this process fails for whatever reason, the original image will be restored. 
On success, the original image is completely overwritten and is no longer available.

These features can also be used via [Rake](rake.html) or [Capistrano](capistrano.html). The latter 
gives you the option of setting up your deploy to automatically convert your images on your external servers.

### Installation

If you're using bundler, just add the following to your Gemfile:

	gem 'tiny_png'