require 'rubygems'
#require 'google/api_client'

module Rankable
  def rank token=nil
  end

  def get
  end

  module Facebook
    def rank token=nil
      likes = get
      graph = Koala::Facebook::API.new(token)

      if token.nil?
=begin
        likes.each_with_index do |like,index|
          begin
            f=graph.get_connections("","#{like['id']}")
    
            #eligible = f['is_verified']
            #eligible = eligible && f['likes'] > 10000
            #higher number of likes 
            eligible = f['likes'] > 100000 || true
              
            #FIXME make this in post level => status post, authentic wall posting,
            #if f['type']=="status" && f['story'].nil? 
    
            FbPage.new({:eligible=>eligible,:page_id=>like['id'],:info=>f}).save! if eligible
          rescue Exception => e
            puts "error ranking fb page"
          end
        end
=end
      else
        slice = likes.each_slice(50).to_a
        result=[]  

        slice.each do |part|
          result +=  graph.batch do |batch_api|
            part.each do |p|
              batch_api.get_connections("","#{p['id']}")
            end
          end
        end
        
        pages=[]
        result.each do |r|
          #eligible = f['is_verified']
          #eligible = eligible && f['likes'] > 10000
          #higher number of likes 
          eligible = r['likes'] > 100000 || true
            
          #FIXME make this in post level => status post, authentic wall posting,
          #if f['type']=="status" && f['story'].nil? 
            
          pages << {:eligible=>true,:page_id=>r['id'],:info=>r} if eligible
        end
  
        FbPage.create(pages)
        pages
      end            
    end
  end
  
  module Google_
    def rank token=nil
      subscriptions=get

      client = Google::APIClient.new(
        :key => 'AIzaSyAirpl4Ht0VAYhkOnUhmSm3k_YpXoxyE90',
        :authorization => nil,
        :application_name => '4linked',
        :application_version => '1.0.0'
      )

      channels=[]
      batch = Google::APIClient::BatchRequest.new do |channel|
        channels<<{:eligible=>true,:channel_id=>channel.data.items.first.id,:info=>{
          :uploads=>channel.data.items.first.contentDetails.relatedPlaylists.uploads,
          :items=>JSON.parse(channel.data.items.first.to_json)
        }}
      end
      
      subscriptions.each_with_index do |sub,index|
        batch.add({
          :api_method => client.discovered_api("youtube", "v3").channels.list,
          :parameters => {
            id: sub['snippet']['resourceId']['channelId'],
            :part => 'snippet,contentDetails',
            :maxResults=>1}        
        })
      end
  
      client.execute!(batch)
      
      YtbChannel.create(channels)
      channels
      #YtbChannel.new({:eligible=>true,:channel_id=>sub['snippet']['resourceId']['channelId'],:info=>channels}).save!
       
=begin
      subscriptions.each_with_index do |sub,index|
        channel=client.execute!(
          :api_method => client.discovered_api("youtube", "v3").channels.list,
          :parameters => {
            id: sub['snippet']['resourceId']['channelId'],
            :part => 'snippet,contentDetails',
            :maxResults=>1})

        info={
          :uploads=>channel.data.items.first.contentDetails.relatedPlaylists.uploads,
          :items=>JSON.parse(channel.data.items.first.to_json)
        }

        YtbChannel.new({:eligible=>true,:channel_id=>sub['snippet']['resourceId']['channelId'],:info=>info}).save!
      end
=end
    end
  end

  module Linkedin
    def rank token=nil
    end
  end

  module Twitter
    def rank token=nil
    end
  end
  
  module Instagram
    def rank token=nil
    end
  end
end

=begin
  FORNOW: for now very simple just verified pages and high number of likes
  FORNOW: BE ABLE TO RANK ONLY USER PAGES AND SAVE THEM
=end

=begin
CHECK:
algorithm to rank relevance in facebook pages
threshold: number of page likes, number of results on google, keywords, black list, category weight/relevance, created-time


BE ABLE TO RANK ALL PAGES / UPDATE DATA / 
company: can be important. only if verified and high number of likes
Amateur sports team: no sense i think
community: can be important
local business: no sense
camera/photo: no sense
media/news/publishing: can be important
clothing: can be important
product/service: can be important
food/beverage: can be important
restaurant/cafe: no sense
app page: no sense but look at category_ilst
university: can be
school: can be
movie: no sense
public figure: can be
sociey/culture website: can be
consulting/business services: no sense
Athlete: can be
non-profit org: can be
computers/technology: no sense
tv show: can be
personal blog: no sense
tv channel: can be
business/economy website: no sense
news/media website: can be
magazine: can be
organization: can be
sport/recreation/activities: no sense
city: can be
automotive: can be
health/personal/pharmacy: can be
professional services: no sense
cause: no sense
 
=end