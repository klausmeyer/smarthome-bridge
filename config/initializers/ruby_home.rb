# Do not store the YAML files in the root directory
RubyHome::AccessoryInfo.source   = 'data/accessory_info.yml'
RubyHome::IdentifierCache.source = 'data/identifier_cache.yml'

RubyHome.configure do |config|
  config.discovery_name = ENV['RUBYHOME_NAME'] || 'Ruby Home'
end

RubyHome::ServiceFactory.create(:accessory_information)
