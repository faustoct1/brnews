#require 'bundle/bundler/setup'

#require 'padrino-core'
require 'mongoid'
require 'pg'
require 'redis'
require 'json'
require 'koala'
require 'google/api_client'
require 'iron_worker_ng'
require 'rest_client'

puts "start"

=begin
["database", "rankable", "chain_executor", "feed_lookup", "feed_lookup", "profile_lookup", "user", "provider",
  "fb_like",  "ytb_subscription",  "fb_page", "ytb_channel"].each do |file|
  puts "Loading #{file}"
  require file
end
=end

def skip? f
  if f.class == Koala::Facebook::ClientError
    puts f.to_json
  end

  f.nil? || f.class == Koala::Facebook::ClientError || f.empty?
=begin
f.first['from']['category'] == "App page" || f.first['from']['category'] == "Musician/band" ||
    f.first['from']['category'] == "Cause" || f.first['from']['category'] == "Tv show" || f.first['from']['category'] == "Home decor" ||
    f.first['from']['category'] == "Athlete" || f.first['from']['category'] == "City" || f.first['from']['category'] == "Arts/humanities website" ||
    f.first['from']['category'] == "Radio station" || f.first['from']['category'] == "Entertainment website" || f.first['from']['category'] == "Computers/technology" ||
    f.first['from']['category'] == "Movie"
=end
end

#build facebook stories
def fbstories session, conn, last_published
  pages = session[:fb_pages].find()

  return if pages.count.zero?

  result=[]
  unless pages.nil?
    access_token = RestClient.get("")
    token = access_token.split("=")[1]
    graph = Koala::Facebook::API.new(token)

    slice = pages.each_slice(50).to_a
    slice.each do |part|
      result +=  graph.batch do |batch_api|
        part.each do |p|
          batch_api.get_connections("#{p['page_id']}", "feed?limit=1")
        end
      end
    end
  end

  #fbfeed=[]
  puts "total fbfeed #{result.count}"
  #FIXME ADD UNIQUE INDEX TO REPEATED PAGES

  conn.prepare('fb', 'insert into stories (social_id, social, published, title, description, fb_type,  fb_from_category,  fb_from_name,  fb_from_id,  fb_status_type,  fb_message,  fb_link,  fb_caption, fb_story, fb_pic, fb_icon) values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)')

  jumps=[]
  ignore_duplicates = []
  result.each do |r|
    if skip?(r)
      jumps << r
    else
      published = Time.parse(r.first["created_time"]).to_i
      next if published <= last_published

=begin
      fbdata = {
        from: :facebook,
        refid: r.first["from"]["id"],
        type: r.first["type"],
        _from: r.first["from"],
        status_type: r.first["status_type"],
        message: r.first["message"],
        link: r.first["link"],
        name: r.first["name"],
        caption: r.first["caption"],
        description: r.first["description"],
        published: Time.parse(r.first["created_time"]).to_i,
      }
=end

      #session[:stories].insert(fbdata)
      begin
        conn.exec_prepared('fb', [r.first["from"]["id"], :facebook, published, r.first["name"], r.first["description"], r.first["type"], r.first["from"]["category"], r.first["from"]["name"], r.first["from"]["id"], r.first["status_type"], r.first["message"], r.first["link"], r.first["caption"], r.first["story"], r.first["picture"], r.first["icon"]])
      rescue PG::UniqueViolation => e
        ignore_duplicates << r
        #keep going. ignore duplicate items!
      end
    end
  end
  puts "total jumped fbfeed #{jumps.count}"
  puts "total ignore_duplicates #{ignore_duplicates.count}"
end

#build youtube stories
def ytbstories session, conn, last_published
  channels = session[:ytb_channels].find()

  return if channels.count.zero?

  conn.prepare('ytb', 'insert into stories (social_id, social, published, title, description, ytb_thumbnail, ytb_channelId, ytb_videoId, ytb_channel_name) values ($1, $2, $3, $4, $5, $6, $7, $8, $9)')

  client = Google::APIClient.new(
    :key => '',
    :authorization => nil,
    :application_name => '4linked',
    :application_version => '1.0.0'
  )

  ignore_duplicates = []

  batch = Google::APIClient::BatchRequest.new do |video|
    next if video.data.items.first.nil?
    ytbdata = video.data.items.first.snippet

    published = ytbdata["publishedAt"].to_i
    next if published <= last_published

    data = {
      from: :google_oauth2,
      refid: ytbdata["channelId"],
      published: ytbdata["publishedAt"].to_i,
      title: ytbdata["title"],
      description: ytbdata["description"],
      thumbnail: ytbdata["thumbnails"]["default"]["url"],
      channelId: ytbdata["channelId"],
      videoId: ytbdata["resourceId"]["videoId"],
    }
    #session[:stories].insert(data) unless video.data.items.first.nil?

    begin
      conn.exec_prepared('ytb', [ytbdata["channelId"], :google_oauth2, published, ytbdata["title"], ytbdata["description"], ytbdata["thumbnails"]["default"]["url"], ytbdata["channelId"], ytbdata["resourceId"]["videoId"], ytbdata["channelTitle"] ]) unless video.data.items.first.nil?
    rescue PG::UniqueViolation => e
      ignore_duplicates << r
      #keep going. ignore duplicate items!
    end
  end

  channels.each_with_index do |channel,index|
    batch.add({
      :api_method => client.discovered_api("youtube", "v3").playlist_items.list,
        :parameters => {
          :playlistId => channel['info']['uploads'],
          :part => 'snippet',
          :maxResults=>1}
    })
  end

  client.execute!(batch)

  puts "total ignore_duplicates #{ignore_duplicates.count}"
end

#payload = JSON.parse(payload, symbolize_names: true)
session = Moped::Session.connect("")

uri = URI.parse("")
conn = PG.connect( dbname: uri.path[1..-1], port: uri.port, host: uri.host, password: uri.password, user: uri.user )

last_published=nil
conn.exec( "select max(published) from stories limit 1" ) do |a|
  last_published = a.first["max"].to_i
end


fbstories session, conn, last_published
ytbstories session, conn, last_published
session.logout
conn.close


=begin
redis_feed = Redis.new(url: "redis://rediscloud:aLUeohWmMX3tXIZh@pub-redis-14150.us-east-1-1.1.ec2.garantiadata.com:14150")
redis_feed.set(id,  user.feeds.to_json)
redis_feed.quit

RestClient.get("http://feed.4linked.com/me/#{id}")
=end

=begin
uri = URI.parse("redis://redistogo:77a8620891086a99c5cf56d02a681e6e@scat.redistogo.com:9485/")
session = Moneta.new(:Redis, host: uri.host, port: uri.port, password: uri.password, expires: false)
hash=session[id]
hash["user"]=account.id.to_s
session[id]=hash
=end

puts "end"
