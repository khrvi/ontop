# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Enable the breakpoint server that script/breakpointer connects to
#config.breakpoint_server = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
#config.action_view.cache_template_extensions         = false
config.action_view.debug_rjs                         = true

# Don't care if the mailer can't send
#config.action_mailer.raise_delivery_errors = false
config.action_mailer.delivery_method = :smtp
config.action_mailer.raise_delivery_errors = true
config.action_mailer.perform_deliveries = true
config.action_mailer.default_charset = "utf-8"


config.action_controller.session = {
    :session_key => '_ontop_session_id',
    :secret      => 'e229fa3089d0e5226c08a818db671edc84c8a78d4f486c337dc458868c511802a100617451108f3e8183d39b3635851755debb67dc48d12053ce15cb7d84fabe'
  }