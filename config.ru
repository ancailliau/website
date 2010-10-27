#!/usr/bin/env rackup
require "rubygems"
gem 'wlang', '< 1.0.0'
gem 'waw',   '< 0.4.0'
require 'wlang'
require 'waw'
run Waw.autoload(__FILE__)
