#require 'bundle/bundler/setup'

require 'padrino-core'
require 'moneta'
require 'mongoid'
require 'redis'
require 'json'
require 'koala'
require 'google/api_client'
require 'iron_worker_ng'
require 'rest_client'
require "pg"

puts "start"

["mongodb", "rankable", "chain_executor", "feed_lookup", "feed_lookup", "profile_lookup", "user", "provider",
  "fb_like",  "ytb_subscription",  "fb_page", "ytb_channel"].each do |file|
  puts "Loading #{file}"
  require file
end

json= JSON.parse(payload)

data = json['data']
id = json['user_id']
provider = data['provider']
result = Auth::Provider.auth(data,id)

exit if result[:provider_type].nil?

account = result[:user]
model = Auth::Provider.scrapy_provider account.id.to_s, data['provider']

=begin
uri = URI.parse("redis://rediscloud:LppVZuO1D7rY3uRG@pub-redis-15495.us-east-1-3.2.ec2.garantiadata.com:15495")
redis_api = Moneta.new(:Redis, host: uri.host, port: uri.port, password: uri.password, expires: false)
redis_api["user_#{id}_profiles"]=nil
redis_api.close
=end

=begin
uri = URI.parse("postgres://vnlwtbjaepbqbw:LkPMzAEHhU-iHKIO2GOCTmJqKw@ec2-23-21-73-32.compute-1.amazonaws.com:5432/d893d13uq5ru7t")
conn = PG.connect( dbname: uri.path[1..-1], port: uri.port, host: uri.host, password: uri.password, user: uri.user )

case provider
  when "facebook"
    fb_pages = model

    conn.prepare('statement1', 'insert into user_social (user_id, social_id, social) values ($1, $2, $3)')
    fb_pages.each do |fbp|
      begin
	conn.exec_prepared('statement1', [ id, fbp[:page_id], :facebook ])
      rescue PG::UniqueViolation => e
        puts "UK violation facebook #{fbp[:page_id]}"
      end
    end

    puts "inserted #{fb_pages.count} fbpages + social"
  when "google_oauth2"
    ytb_subs= model

    conn.prepare('statement1', 'insert into user_social (user_id, social_id, social) values ($1, $2, $3)')
    ytb_subs.each do |ytb|
      begin
        conn.exec_prepared('statement1', [ id, ytb[:channel_id], :google_oauth2 ])
      rescue PG::UniqueViolation => e
	puts "UK violation google_oauth2 #{ytb[:channel_id]}"
      end
    end

    puts "inserted #{ytb_subs.count} ytbchannels + social"
end

conn.close
=end

puts "end"
