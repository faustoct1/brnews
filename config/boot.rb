# Defines our constants
RACK_ENV  = ENV['RACK_ENV'] ||= 'development'  unless defined?(RACK_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
#require 'rubygems' unless defined?(Gem)
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

##
# ## Enable devel logging
#
Padrino::Logger::Config[:production][:log_level]  = :devel
Padrino::Logger::Config[:production][:stream] = :stdout

Padrino::Logger::Config[:development][:log_level]  = :devel
Padrino::Logger::Config[:development][:stream] = :stdout
#Padrino::Logger::Config[:development][:log_static] = true
#
# ## Configure your I18n
#
# I18n.default_locale = :en
#
# ## Configure your HTML5 data helpers
#
# Padrino::Helpers::TagHelpers::DATA_ATTRIBUTES.push(:dialog)
# text_field :foo, :dialog => true
# Generates: <input type="text" data-dialog="true" name="foo" />
#
# ## Add helpers to mailer
#
# Mail::Message.class_eval do
#   include Padrino::Helpers::NumberHelpers
#   include Padrino::Helpers::TranslationHelpers
# end

##
# Add your before (RE)load hooks here
#
Padrino.before_load do
  require 'google/api_client'
  ['app/classes/auth/provider.rb'].each do |file|
    logger.devel "LOADING #{file}"
    require Padrino.root(file)
  end

=begin
  ['app/classes/rank/rankable.rb', 'app/classes/auth/provider.rb', 'app/classes/executor/chain_executor.rb',
    'app/classes/executor/feed_lookup.rb', 'app/classes/executor/profile_lookup.rb', 'config/database.rb'].each do |file|
    logger.devel "LOADING #{file}"
    require Padrino.root(file)
  end
=end
  # Encoding.default_external = Encoding::UTF_8
  # Encoding.default_internal = Encoding::UTF_8 # <- THIS
end

##
# Add your after (RE)load hooks here
#

Padrino.after_load do
  Encoding.default_internal = nil
  #Sinatra::Synchrony.overload_tcpsocket!
end

# Mongoid.load!("config/mongoid.yml")
#Padrino.set_load_paths('app/classes')
#$LOAD_PATH.concat("app/classes")
=begin
  #Linked4.prerequisites
  Linked4::App.dependencies << Padrino.root('classes/**/*.rb')
  #FIXME replace puts for loggers
  Dir[Padrino.root('classes/**/*.rb')].each do |file|
    logger.devel "LOADING #{file}"
    require file
  end
=end



Padrino.load!
