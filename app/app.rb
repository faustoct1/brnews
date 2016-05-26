require 'sinatra/base'

module Linked4
  class App < Padrino::Application
    configure { set :server, :puma }

    register LessInitializer
    register Padrino::Rendering
    register Padrino::Helpers
    register Padrino::Cookies
    register Padrino::Mailer

    #register Padrino::Cache
    #register OmniauthInitializer

    use Rack::Deflater
    use ConnectionPoolManagement

    #enable :caching

=begin
    if ENV['REDISTOGO_URL']
      uri = URI.parse(ENV["REDISCLOUD_URL"])
      set :cache, Padrino::Cache.new(:Redis, :host => uri.host, :port => uri.port, :password => uri.password, :db => 0)
    else
      uri = URI.parse("")
      set :cache, Padrino::Cache.new(:Redis, :host => uri.host, :port => uri.port, :password => uri.password, :db => 0)
    end

    before do
      #cache_control :public, :max_age => 86400
      session[:init] ||= true unless session.loaded?
    end
=end

=begin
    before :settings do
      redirect '/' if session[:user].nil?
    end
=end

=begin
    before :me do
      redirect '/' if session[:user].nil?
    end
=end

=begin
    before '/auth/logout' do
      redirect '/' if session[:user].nil?
    end

    before :home do
      #logger.info request.path
      #logger.info session.object_id
      #logger.info session.inspect
      #logger.info session[:user]
      redirect '/' if session[:user].nil?
    end

    before :index do
      redirect '/home' unless session[:user].nil?
    end
=end

=begin
    before /auth\/registration\/*/ do
      if session[:registration_step].nil?
        redirect '/home' unless session[:user].nil?
      end

      #if !session[:registration_step].nil?
      #  #should come here only once!
      #  #session[:registration_step]=nil
      #else
      #  redirect '/home' unless session[:user].nil?
      #end
    end
=end
    #global error handling!
    #since padrino is based on sinatra you can use http://www.sinatrarb.com/intro.html#Not%20Found
    not_found do
      logger.info "not found"
      redirect '/' #general error handling when route isn't found! http 404!
    end

    error do
      logger.info "error"
      redirect '/' # @error = request.env['sinatra_error'].name
    end
  end
end

#register Padrino::Admin::AccessControl
# use ActiveRecord::ConnectionAdapters::ConnectionManagement

#enable :sessions
#set :sessions, :expire_after => 5.minutes

##
# Caching support
#
# register Padrino::Cache
# enable :caching
#
# You can customize caching store engines:
#
# set :cache, Padrino::Cache::Store::Memcache.new(::Memcached.new('127.0.0.1:11211', :exception_retry_limit => 1))
# set :cache, Padrino::Cache::Store::Memcache.new(::Dalli::Client.new('127.0.0.1:11211', :exception_retry_limit => 1))
# set :cache, Padrino::Cache::Store::Redis.new(::Redis.new(:host => '127.0.0.1', :port => 6379, :db => 0))
# set :cache, Padrino::Cache::Store::Memory.new(50)
# set :cache, Padrino::Cache::Store::File.new(Padrino.root('tmp', app_name.to_s, 'cache')) # default choice
#


=begin
    if ENV['REDISTOGO_URL']
      uri = URI.parse(ENV["REDISTOGO_URL"])
      set :cache, Padrino::Cache.new(:Redis, :host => uri.host, :port => uri.port, :password => uri.password, :db => 0)
    else
      uri = URI.parse("redis://redistogo:77a8620891086a99c5cf56d02a681e6e@scat.redistogo.com:9485/")
      set :cache, Padrino::Cache.new(:Redis, :host => uri.host, :port => uri.port, :password => uri.password, :db => 0)
    end
=end

    ##
    # Application configuration options
    #
    # set :raise_errors, true       # Raise exceptions (will stop application) (default for test)
    # set :dump_errors, true        # Exception backtraces are written to STDERR (default for production/development)
    # set :show_exceptions, true    # Shows a stack trace in browser (default for development)
    # set :logging, true            # Logging in STDOUT for development and file for production (default only for development)
    # set :public_folder, 'foo/bar' # Location for static assets (default root/public)
    # set :reload, false            # Reload application files (default in development)
    # set :default_builder, 'foo'   # Set a custom form builder (default 'StandardFormBuilder')
    # set :locale_path, 'bar'       # Set path for I18n translations (default your_app/locales)
    # disable :sessions             # Disabled sessions by default (enable if needed)
    # disable :flash                # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
    # layout  :my_layout            # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
    #

    ##
    # You can configure for a specified environment like:
    #
    #   configure :development do
    #     set :foo, :bar
    #     disable :asset_stamp # no asset timestamping for dev
    #   end
    #

    ##
    # You can manage errors like:
    #
    #   error 404 do
    #     render 'errors/404'
    #   end
    #
    #   error 505 do
    #     render 'errors/505'
    #   end
    #

    # get '/' do
    #     haml :index
    # end
