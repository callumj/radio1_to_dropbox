# encoding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = "radio1_to_dropbox"
  s.version     = "0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Callum Jones"]
  s.email       = ["callum@callumj.com"]
  s.homepage    = "http://callumj.com"
  s.summary     = "Downloads Radio 1 shows to Dropbox"
                  
  s.description = "Downloads Radio 1 shows to Dropbox"
  
  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency("radio_keeper")
  s.add_dependency("dropbox-api")
  s.add_dependency("activesupport")
 
  s.files        = Dir.glob("lib/**/*") +
    %w(README.md Rakefile)
  s.require_path = 'lib'
end