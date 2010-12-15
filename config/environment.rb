# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
ENV['RAILS_ENV']= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.0' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
#  ENV['NLS_LANG'] = 'american_america.AL32UTF8'
#
  ENV['LANG']     = 'american_america.AL32UTF8'
#  ENV['LC_CTYPE'] = 'american_america.AL32UTF8'
#  $KCODE = 'UTF8'
  #require 'acts_as_ferret'
  #Ferret.locale   = 'american_america.AL32UTF8'

  # Settings in config/environments/* take precedence over those specified here

  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  # See Rails::Configuration for more options

  AUTHORIZATION_MIXIN = "object roles"
  DEFAULT_REDIRECTION_HASH = { :controller => 'account', :action => 'login' }
  STORE_LOCATION_METHOD = :store_return_location
DEFAULT_LANGUAGE = 'ru'
  SUPPORTED_LANGUAGES = {
    'de' => ['de-CH', 'Deutsch', 'Deutsche Version'],
    'en' => ['en-US', 'English', 'English Version'],
    'ru' => ['ru-RU', 'Russion', 'Russion Version']

  }
end

#include Globalize
#Locale.set_base_language('de-CH')

# Add new inflection rules using the following format
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

# Include your application configuration below

class Array
  def swap!(a,b)
    self[a], self[b] = self[b], self[a]
    self
  end
end

class String
  def each_to_a *sep
    result = []
    self.each(*sep) do |s|
      result << s.chomp(*sep).strip
    end
    result
  end
end




require 'usermonitor'
ActiveRecord::Base.class_eval do
  include ActiveRecord::UserMonitor
end

## Oracle CLOB patch
#require 'active_record/connection_adapters/abstract_adapter'
#require 'delegate'
#
#begin
#  require_library_or_gem 'oci8' unless self.class.const_defined? :OCI8
#  module ActiveRecord
#    module ConnectionAdapters #:nodoc:
#      class OracleAdapter < AbstractAdapter
#        def native_database_types #:nodoc:
#          {
#            :primary_key => "NUMBER(38) NOT NULL PRIMARY KEY",
#            :string      => { :name => "VARCHAR2", :limit => 255 },
#            :text        => { :name => "VARCHAR2", :limit => 4000 },
#            :integer     => { :name => "NUMBER", :limit => 38 },
#            :float       => { :name => "NUMBER" },
#            :decimal     => { :name => "DECIMAL" },
#            :datetime    => { :name => "DATE" },
#            :timestamp   => { :name => "DATE" },
#            :time        => { :name => "DATE" },
#            :date        => { :name => "DATE" },
#            :binary      => { :name => "BLOB" },
#            :boolean     => { :name => "NUMBER", :limit => 1 }
#          }
#        end
#        def quote(value, column = nil) #:nodoc:
#          if column && [:binary].include?(column.type)
#            %Q{empty_#{ column.sql_type.downcase rescue 'blob' }()}
#          else
#            super
#          end
#        end
#
#      end
#    end
#  end
#
#rescue LoadError
#  # OCI8 driver is unavailable.
#  module ActiveRecord # :nodoc:
#    class Base
#      @@oracle_error_message = "Oracle/OCI libraries could not be loaded: #{$!.to_s}"
#      def self.oracle_connection(config) # :nodoc:
#        # Set up a reasonable error message
#        raise LoadError, @@oracle_error_message
#      end
#      def self.oci_connection(config) # :nodoc:
#        # Set up a reasonable error message
#        raise LoadError, @@oracle_error_message
#      end
#    end
#  end
#end

#require 'acts_as_ferret'

# class ActiveRecord::Base
#   def self.wnw_ferret fields
#     acts_as_ferret({:fields => if fields.kind_of? Array then fields else [fields] end}, {:analyzer => Ferret::Analysis::StandardAnalyzer.new([])})
#   end
# end
