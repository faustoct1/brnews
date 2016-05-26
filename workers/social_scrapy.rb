#require 'bundle/bundler/setup'

require 'padrino-core'
require 'active_record'
require 'json'
require 'koala'
require 'google/api_client'
#require 'iron_worker_ng'
require 'rest_client'
#require 'net/http'
#require 'uri'

puts "start"

=begin
#use this for running with ironworker
["database","story","source","topic","source_topic","user_topic", "source_miss"].each do |file|
  puts "Loading #{file}"
  require file
end
=end

["./config/database", "./models/story","./models/source","./models/topic","./models/source_topic","./models/user_topic", "./models/source_miss"].each do |file|
  puts "Loading #{file}"
  require file
end

class GrabException < Exception
end

Koala.config.api_version = "v2.4"

def get_source r,by, url
  domain = url.gsub(/https?:\/\//,'').gsub(/\/.*/,'')

  raise GrabException, "Url empty" if domain.empty?

  sources = Source.where("#{by} LIKE ? ", "%#{domain}%")
  source = nil

  if by == 'fb_id'
    source = sources.first
  else
    if sources.empty?
      rtry = 2 #can have more than 1 redirect!

      while rtry!=0
        #url  = r.first["link"]
        puts url
        location = Net::HTTP.get_response(URI.parse(url))['location']
        redir_url = location.nil? ? url : location
        redir_url = redir_url.gsub(/https?:\/\//,'').gsub(/\/.*/,'')
        source = Source.where("#{by} LIKE ?", "%#{redir_url}%").first
puts redir_url
        break if location.nil? || !source.nil?

        rtry = rtry - 1
      end

      raise GrabException, "Source unregistered #{location.nil? ? url : location}" if source.nil?
    end

    url_size = 0
    sources.each do |s|
      #puts "here"
      website = s[:website]
      length = website.length
      if length > url_size && url.include?(website)
        url_size = length
        source = s
      end
    end
  end

  topics = source.nil? ? :nil : source.topics
  if topics.nil? || topics.size!=1
    raise GrabException, "Source unregistered #{url}"
  end
  source
end

def get_topic r, by, url
  source = get_source r, by, url
  topics = source.topics
  raise GrabException, "Topics size #{topics.size}" if topics.size != 1
  Topic.select(:id).where(name: topics.first.name).first[:id]
end

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
def fbstories last_published
  ids = Source.select(:fb_id).where('fb_id is not null')

  return if ids.size.zero?

  result=[]
  unless ids.nil?
    access_token = RestClient.get("")
    token = access_token.split("=")[1]
    graph = Koala::Facebook::API.new(token)

    slice = ids.each_slice(50).to_a
    slice.each do |part|
      result +=  graph.batch do |batch_api|
        part.each do |p|
          batch_api.get_connections("#{p[:fb_id]}", "feed?fields=created_time,description,from,message,story,status_type,link,name,type,full_picture,picture&limit=1")
        end
      end
    end
  end

  #fbfeed=[]
  puts "total fbfeed #{result.count}"
  #FIXME ADD UNIQUE INDEX TO REPEATED PAGES

  jumps=[]
  ignore_duplicates = []
  result.each do |r|
    if skip?(r)
      jumps << r
    else
      published = Time.parse(r.first["created_time"]).to_i

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

      #post not from the page. it is from somebody else
      next if published <= last_published ||
      r.first["status_type"]=="wall_post" ||
      r.first["type"]=="status" ||
      !r.first["id"].include?(r.first["from"]["id"]) ||
      r.first["link"].nil? ||
      r.first["link"].empty?

      puts "\n\n"

      begin
        begin
          puts "going from fb photo|video"
          topic_id = get_topic r, 'fb_id', r.first['from']['id']
          qtitle = r.first["name"].blank? ? nil : r.first["name"].gsub(/\s+/, '-')
          Story.create(uid_url: r.first["from"]["id"], source_type: 'facebook', published: published, title: r.first["name"], description: r.first["description"], fb_type: r.first["type"],  fb_from_category: r.first["from"]["category"],  fb_from_name: r.first["from"]["name"], fb_from_id: r.first["from"]["id"], fb_status_type: r.first["status_type"],  fb_message: r.first["message"],  fb_link: r.first["link"], fb_caption: r.first["caption"], fb_story: r.first["story"], fb_pic: r.first["picture"], fb_icon: r.first["icon"], topic_id: topic_id, qtitle: qtitle, fb_full_pic: r.first["full_picture"])
          puts "caught directly from fb photo|video"
          next
        rescue GrabException => e
          puts "but raise an exception #{r.first['from']['id']} - #{r.first['message']} - #{e.message}"
        end

        puts "so, we're trying by the link/website"

        url = r.first["link"]
        url_no_proto = url.gsub(/https?:\/\//,'')

        if url_no_proto.starts_with?("www.facebook.com")
          #url = url.gsub(/https?:\/\/www\.facebook\.com\/.+\/(videos?|photos?\/.+)/,'\1')
=begin
          if /videos?|photos?\/.+/.match(url).nil?
            SourceMiss.create(uid: r.first["from"]["id"], url: r.first["link"], source_type: :facebook, reason: "Url Facebook not video/foto")
            puts "Url Facebook not video/foto: #{r.first["from"]["id"]} - #{r.first["link"]} - #{url}"
            next
          end
=end
          #dont' have topic associate with fb_page, so try to find the first link on message body.
          message = r.first['message'].split(/\s+/).find_all { |u| u =~ /(^https?:|[.+\.+]{1}\/.*)/ }
          #url = message[0].gsub(/https?:\/\//,'') unless message.empty?
          url = message[0] unless message.empty?
        end

        #dont' have topic associate with fb_page, so try to find the first link on message body.
        topic_id = get_topic r, 'website', url
        qtitle = r.first["name"].blank? ? nil : r.first["name"].gsub(/\s+/, '-')
        Story.create(uid_url: r.first["from"]["id"], source_type: 'facebook', published: published, title: r.first["name"], description: r.first["description"], fb_type: r.first["type"],  fb_from_category: r.first["from"]["category"],  fb_from_name: r.first["from"]["name"], fb_from_id: r.first["from"]["id"], fb_status_type: r.first["status_type"],  fb_message: r.first["message"],  fb_link: r.first["link"], fb_caption: r.first["caption"], fb_story: r.first["story"], fb_pic: r.first["picture"], fb_icon: r.first["icon"], topic_id: topic_id, qtitle: qtitle,  fb_full_pic: r.first["full_picture"])
        puts "caught by the website"
      rescue PG::UniqueViolation => e
        ignore_duplicates << r
        #keep going. ignore duplicate items!
      rescue GrabException => e
        SourceMiss.create(uid: r.first["from"]["id"], url: r.first["link"], source_type: :facebook, reason: e.message)
        puts "#{e.message}: #{r.first["from"]["id"]} - #{r.first["link"]} - #{url}"
      end
    end
  end

  puts "total jumped fbfeed #{jumps.count}"
  puts "total ignore_duplicates #{ignore_duplicates.count}"
end

#build youtube stories
def ytbstories last_published
  channels = Source.select(:id, :from).where(name:[:google_oauth2])

  return if channels.size.zero?

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

=begin
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
=end

    begin
      Story.create(source: page[:id], source_type: 'google_oauth2', published: published, title:ytbdata["title"], description:ytbdata["description"], ytb_thumbnail:ytbdata["thumbnails"]["default"]["url"], ytb_channelId:ytbdata["channelId"], ytb_videoId:ytbdata["resourceId"]["videoId"], ytb_channel_name: ytbdata["channelTitle"]) unless video.data.items.first.nil?
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


#last_published=.published rescue exit
last_published = Story.maximum(:published)
last_published = 0 if last_published.nil?

fbstories last_published
ytbstories last_published

puts "end"
