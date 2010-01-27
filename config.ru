#!/usr/bin/env rackup
require "rubygems"
gem 'wlang', '< 0.9.0'
gem 'waw',   '< 0.2.0'
require 'wlang'
require 'waw'
run Waw.autoload(__FILE__)
