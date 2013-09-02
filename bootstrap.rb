APP_PATH = File.dirname(__FILE__)

require 'bundler'
Bundler.require :default

$:.unshift File.join(APP_PATH, "lib")

require 'active_support/all'

require 'radio1_to_dropbox'