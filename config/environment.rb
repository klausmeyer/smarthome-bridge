app_env = ENV['APP_ENV'] || 'development'

bundler_groups = [:default]
bundler_groups << :development if app_env == 'development'

require 'bundler'
Bundler.require(*bundler_groups)

require 'active_support'
require 'active_support/all'

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Dir['./config/initializers/*.rb'].each{ |f| require f }

require 'app'
require 'entry'
require 'registry'
