ENV['RAILS_ENV']= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.0' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  AUTHORIZATION_MIXIN = "object roles"
  DEFAULT_REDIRECTION_HASH = { :controller => 'account', :action => 'login' }
  STORE_LOCATION_METHOD = :store_return_location
end

require 'usermonitor'
ActiveRecord::Base.class_eval do
  include ActiveRecord::UserMonitor
end
