require 'dropbox-api'
require 'active_support/all'

require 'radio1_to_dropbox/tools'

module Radio1ToDropbox

  def self.dropbox_config!
    Dropbox::API::Config.app_key    = ENV["DROPBOX_TOKEN"]
    Dropbox::API::Config.app_secret = ENV["DROPBOX_SECRET"]
    Dropbox::API::Config.mode       = "sandbox"
  end

  def self.dropbox_client
    dropbox_config!
    Dropbox::API::Client.new(:token => ENV["DROPBOX_USER_TOKEN"], :secret => ENV["DROPBOX_USER_SECRET"])
  end

end