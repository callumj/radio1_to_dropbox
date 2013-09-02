load File.join(File.dirname(__FILE__), "bootstrap.rb")

task :console do
  Bundler.require :default, :development
  binding.pry
end


task :process_latest do
  Radio1ToDropbox::Tools.download_latest_show
end